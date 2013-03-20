module Vagrant
  module Notify
    module Action
      class StopServer
        def initialize(app, env)
          @app = app
        end

        def call(env)
          pid = env[:notify_data][:pid]

          Process.kill('KILL', pid.to_i) rescue nil

          env[:notify_data][:pid]  = nil
          env[:notify_data][:port] = nil

          @app.call env
        end
      end
    end
  end
end
