module Vagrant
  module Notify
    module Middleware
      class StartServer
        def initialize(app, env)
          @app = app
        end

        def call(env)
          @env = env
          if pid = server_is_running?
            env[:ui].info "Notification server is already running (#{pid})"
          else
            port, pid = run_server
            env[:ui].info "Notification server is listening on #{port} (#{pid})"
          end

          @app.call(env)
        end

        private

        def run_server
          port = next_available_port
          uuid = @env[:vm].uuid.to_s
          pid  = Server.run(@env, port)

          local_data = @env[:vm].env.local_data
          config = local_data['vagrant-notify'] ||= Vagrant::Util::HashWithIndifferentAccess.new
          config.merge!(uuid => {'pid' => pid, 'port' => port })
          local_data.commit

          [port, pid]
        end

        def next_available_port
          range = @env[:vm].config.vm.auto_port_range.to_a
          range -= @env[:vm].config.vm.forwarded_ports.collect { |opts| opts[:hostport].to_i }
          range -= used_ports

          if range.empty?
            raise 'Unable to find a port to bind the notification server to'
          end

          # Set the port up to be the last one since vagrant's port collision handler
          # will use the first as in:
          #   https://github.com/mitchellh/vagrant/blob/1-0-stable/lib/vagrant/action/vm/check_port_collisions.rb#L51
          port = range.pop
        end

        def used_ports
          local_data = @env[:vm].env.local_data
          local_data['vagrant-notify'] ||= Vagrant::Util::HashWithIndifferentAccess.new
          local_data['vagrant-notify'].values.map do |settings|
            settings['port'].to_i if settings['port']
          end.compact
        end

        # REFACTOR: This is duplicated on Middleware::StopServer
        def server_is_running?
          uuid = @env[:vm].uuid.to_s
          begin
            pid = @env[:vm].env.local_data.
              fetch('vagrant-notify', {}).
              fetch(uuid, {}).
              fetch('pid', nil)
            return false unless pid

            Process.getpgid(pid)
            pid
          rescue Errno::ESRCH
            false
          end
        end
      end
    end
  end
end
