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
          local_data['vagrant-notify'] ||= Vagrant::Util::HashWithIndifferentAccess.new
          local_data['vagrant-notify'][uuid] ||= Vagrant::Util::HashWithIndifferentAccess.new
          local_data['vagrant-notify'][uuid]['pid'] = pid
          local_data['vagrant-notify'][uuid]['port'] = port
          local_data.commit

          [next_available_port, pid]
        end

        def next_available_port
          range = @env[:vm].config.vm.auto_port_range.to_a
          range -= @env[:vm].config.vm.forwarded_ports.collect { |opts| opts[:hostport].to_i }
          range -= used_ports

          if range.empty?
            raise 'Unable to find a port to bind the notification server to'
          end

          # Set the port up to be the first one and add that port to
          # the used list.
          port = range.shift
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
          begin
            pid = @env[:vm].env.local_data.fetch('vagrant-notify', {}).fetch('pid', nil)
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
