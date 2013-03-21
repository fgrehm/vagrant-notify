require_relative '../server'

module Vagrant
  module Notify
    module Action
      class StartServer
        # TODO: This should come from vm configuration or be automatically
        #       assigned
        PORT = '9999'

        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:notify_data][:pid]  = Server.run(env, PORT)
          env[:notify_data][:port] = PORT

          @app.call env
        end
      end
    end
  end
end
