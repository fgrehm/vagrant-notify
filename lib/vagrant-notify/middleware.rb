module Vagrant
  module Notify
    class Middleware
      def initialize(app, env)
        @app = app
      end

      def call(env)
        pid = Server.run
        env[:ui].info "Notification server fired up (#{pid})"
        @app.call(env)
      end
    end
  end
end
