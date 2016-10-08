module Vagrant
  module Notify
    module Action
      class NotifyProvisioningStatus
        def initialize(app, env)
          @app = app
        end

        def call(env)

          system("notify-send '[#{env[:machine].name}] Provisioning with \"#{env[:provisioner_name]}\"...'") unless env[:machine].config.notify.enable == false

          begin
            @app.call(env)
          rescue => msg
            system("notify-send '[#{env[:machine].name}] \"#{env[:provisioner_name]}\" provision failed!'") unless env[:machine].config.notify.enable == false
            env[:machine].ui.error("#{msg}")
          else
            system("notify-send '[#{env[:machine].name}] Finished provisioning with \"#{env[:provisioner_name]}\"'") unless env[:machine].config.notify.enable == false
          end

        end
      end
    end
  end
end
