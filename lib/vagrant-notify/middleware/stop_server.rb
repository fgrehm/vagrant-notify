module Vagrant
  module Notify
    module Middleware
      class StopServer
        def initialize(app, env)
          @app = app
        end

        def call(env)
          # TODO: Logging

          local_data = env[:vm].env.local_data
          local_data['vagrant-notify'] ||= Vagrant::Util::HashWithIndifferentAccess.new
          pid = local_data['vagrant-notify'].fetch('pid', nil)
          Process.kill('KILL', pid.to_i) rescue nil

          @app.call(env)
        end
      end
    end
  end
end
