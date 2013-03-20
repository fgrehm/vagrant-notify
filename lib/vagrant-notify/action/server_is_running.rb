module Vagrant
  module Notify
    module Action
      class ServerIsRunning
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant::notify::action::prepare_data_dir")
        end

        def call(env)
          env[:result] = valid_process?(env[:notify_data][:pid])

          # Call the next if we have one (but we shouldn't, since this
          # middleware is built to run with the Call-type middlewares)
          @app.call env
        end

        private

        def valid_process?(pid)
          Process.getpgid(pid.to_i) if pid
        rescue Errno::ESRCH
          false
        end
      end
    end
  end
end
