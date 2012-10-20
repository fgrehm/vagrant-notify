module Vagrant
  module Notify
    class Middleware
      def initialize(app, env)
        @app = app
      end

      def call(env)
        pid = Server.run

        local_data = env[:vm].env.local_data
        local_data['vagrant-notify'] ||= Vagrant::Util::HashWithIndifferentAccess.new
        local_data['vagrant-notify']['pid'] = pid
        local_data.commit

        env[:ui].info "Notification server fired up (#{pid})"

        @app.call(env)
      end
    end
  end
end
