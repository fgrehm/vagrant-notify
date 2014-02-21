module Vagrant
  module Notify
    module Action
      class NotifyProvisioningStatus
        def initialize(app, env)
          @app = app
        end

        def call(env)
          system("notify-send '[#{env[:machine].name}] Provisioning with \"#{env[:provisioner_name]}\"...'")
          @app.call(env)
          system("notify-send '[#{env[:machine].name}] Finished provisioning with \"#{env[:provisioner_name]}\"'")
        end
      end
    end
  end
end
