module Vagrant
  module Notify
    module Middleware
      class InstallCommand
        def initialize(app, env)
          @app = app
        end

        def call(env)
          @app.call(env)
        end
      end
    end
  end
end
