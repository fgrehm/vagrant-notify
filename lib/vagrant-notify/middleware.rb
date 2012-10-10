module Vagrant
  module Notify
    class Middleware
      def initialize(app, env)
        @app = app
      end

      def call(env)
        env[:ui].info "Hello from '#{env[:vm].name}'!"
        @app.call(env)
      end
    end
  end
end
