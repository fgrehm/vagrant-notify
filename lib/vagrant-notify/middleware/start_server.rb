module Vagrant
  module Notify
    module Middleware
      class StartServer
        def initialize(app, env)
          @app = app
        end

        def call(env)
          if pid = server_is_running?(env)
            env[:ui].info "Notification server is already running (#{pid})"
          else
            pid = run_server(env)
            env[:ui].info "Notification server fired up (#{pid})"
          end

          @app.call(env)
        end

        private

        def run_server(env)
          pid = Server.run

          local_data = env[:vm].env.local_data
          local_data['vagrant-notify'] ||= Vagrant::Util::HashWithIndifferentAccess.new
          local_data['vagrant-notify']['pid'] = pid
          local_data.commit

          pid
        end

        def server_is_running?(env)
          begin
            pid = env[:vm].env.local_data.fetch('vagrant-notify', {}).fetch('pid', nil)
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
