require_relative 'windows/process_info'

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

          unless env[:notify_data][:bind_ip]
            env[:notify_data][:bind_ip] = env[:machine].config.notify.bind_ip if env[:machine].config.notify.bind_ip.is_a?(String)
          end

          # Call the next if we have one (but we shouldn't, since this
          # middleware is built to run with the Call-type middlewares)
          @app.call env
        end

        private

        def valid_process?(pid)
          if RUBY_PLATFORM =~ /mswin|msys|mingw|cygwin|bccwin|wince|emc/
            Vagrant::Notify::Action::Windows::ProcessInfo.queryProcess(pid) if pid
          else
            Process.getpgid(pid.to_i) if pid
          end
          rescue Errno::ESRCH
            false
        end
      end
    end
  end
end
