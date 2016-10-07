require_relative 'action/check_provider'
require_relative 'action/install_command'
require_relative 'action/notify_provisioning_status'
require_relative 'action/prepare_data'
require_relative 'action/server_is_running'
require_relative 'action/set_shared_folder'
require_relative 'action/start_server'
require_relative 'action/stop_server'

module Vagrant
  module Notify
    module Action
      class << self
        Call = Vagrant::Action::Builtin::Call

        def action_start_server
          Vagrant::Action::Builder.new.tap do |b|
            b.use Call, CheckProvider do |env, b2|
              next if !env[:result]

              b2.use PrepareData
              b2.use Call, ServerIsRunning do |env2, b3|
                if env2[:result]
                  env[:machine].ui.success("vagrant-notify-server pid: #{env2[:notify_data][:pid]}")
                else
                  # TODO: b3.use CheckServerPortCollision
                  b3.use StartServer

                  b3.use PrepareData
                  b3.use Call, ServerIsRunning do |env3, b4|
                    if env3[:result]
                      env3[:machine].ui.success("vagrant-notify-server pid: #{env3[:notify_data][:pid]}")
                    else
                      env3[:machine].ui.error("Unable to start notification server using #{env3[:machine].config.notify.bind_ip}")
                    end
                  end
                end
                # Always install the command to make sure we can fix stale ips
                # on the guest machine
                b3.use InstallCommand
              end
            end
          end
        end

        def action_stop_server
          Vagrant::Action::Builder.new.tap do |b|
            b.use Call, CheckProvider do |env, b2|
              next if !env[:result]

              b2.use PrepareData
              b2.use Call, ServerIsRunning do |env2, b3|
                if env2[:result]
                  b3.use StopServer
                  # TODO: b3.use RestoreCommandBackup
                else
                  # TODO: b3.use MessageServerStopped
                end
              end
            end
          end
        end

        def action_status_server
          Vagrant::Action::Builder.new.tap do |b|
            b.use Call, CheckProvider do |env, b2|
              next if !env[:result]

              b2.use PrepareData
              b2.use Call, ServerIsRunning do |env2, b3|
                if env2[:result]
                  env[:machine].ui.success("vagrant-notify-server pid: #{env2[:notify_data][:pid]}")
                else
                  if env[:machine].config.notify.enable == false
                    env[:machine].ui.error("No vagrant-notify server detected. Disabled in Vagrantfile")
                  else
                    env[:machine].ui.error("No vagrant-notify server detected.")
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
