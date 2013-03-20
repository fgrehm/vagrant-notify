require_relative 'action/check_provider'
require_relative 'action/install_command'
require_relative 'action/prepare_data'
require_relative 'action/server_is_running'
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
                  # TODO: b3.use MessageServerRunning
                else
                  # TODO: b3.use CheckServerPortCollision
                  b3.use StartServer
                  # TODO: b3.use BackupCommand
                  b3.use InstallCommand
                end
              end
            end
          end
        end
      end
    end
  end
end
