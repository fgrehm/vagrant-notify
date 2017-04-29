module Vagrant
  module Notify
    module Action
      class NotifyProvisioningStatus
        def initialize(app, env)
          @app = app
        end

        def call(env)
          message = notify_provision_messages(env) unless env[:machine].config.notify.enable == false
          system(message[:start]) unless env[:machine].config.notify.enable == false

          begin
            @app.call(env)
          rescue => msg
            system("notify-send '[#{env[:machine].name}] \"#{env[:provisioner_name]}\" provision failed!'") unless env[:machine].config.notify.enable == false
            env[:machine].ui.error("#{msg}")
          else
            system(message[:end]) unless env[:machine].config.notify.enable == false
          end
        end

        def notify_provision_messages(env)
          message = Hash.new
          if env[:provisioner_name].to_s == 'shell' and env[:provisioner].config.name
            message[:start] = "notify-send '[#{env[:machine].name}] Provisioning with \"#{env[:provisioner_name]} (#{env[:provisioner].config.name})\"...'"
            message[:end] = "notify-send '[#{env[:machine].name}] Finished provisioning with \"#{env[:provisioner_name]} (#{env[:provisioner].config.name})\"'" 
          else
            message[:start] = "notify-send '[#{env[:machine].name}] Provisioning with \"#{env[:provisioner_name]}\"...'"
            message[:end] = "notify-send '[#{env[:machine].name}] Finished provisioning with \"#{env[:provisioner_name]}\"'"
          end
          return message
        end
      end
    end
  end
end
