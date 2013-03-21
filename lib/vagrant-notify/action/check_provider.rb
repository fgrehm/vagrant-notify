module Vagrant
  module Notify
    module Action
      class CheckProvider
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:result] = true

          # Call the next if we have one (but we shouldn't, since this
          # middleware is built to run with the Call-type middlewares)
          @app.call env
        end
      end
    end
  end
end
