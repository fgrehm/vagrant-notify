module Vagrant
  module Notify
    module Action
      class CheckProvider
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:result] = true

          @app.call env
        end
      end
    end
  end
end
