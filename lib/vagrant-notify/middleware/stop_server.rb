module Vagrant
  module Notify
    module Middleware
      class StopServer
        def initialize(app, env)
          @app = app
        end

        def call(env)
          # TODO: Need to handle multi VMs setup

          if pid = server_is_running?(env)
            env[:ui].info('Stopping notification server...')
            stop_server(pid)
            cleanup_local_data(env)
          end

          @app.call(env)
        end

        private

        def stop_server(pid)
          Process.kill('KILL', pid.to_i) rescue nil
        end

        def cleanup_local_data(env)
          uuid = env[:vm].uuid.to_s
          local_data = env[:vm].env.local_data
          local_data['vagrant-notify'] ||= Vagrant::Util::HashWithIndifferentAccess.new
          local_data['vagrant-notify'].delete(uuid)
          local_data.commit
        end

        # REFACTOR: This is duplicated on Middleware::StartServer
        def server_is_running?(env)
          uuid = env[:vm].uuid.to_s
          begin
            pid = env[:vm].env.local_data.
              fetch('vagrant-notify', {}).
              fetch(uuid, {}).
              fetch('pid', nil)
            return false unless pid

            Process.getpgid(pid.to_i)
            pid
          rescue Errno::ESRCH
            false
          end
        end
      end
    end
  end
end
