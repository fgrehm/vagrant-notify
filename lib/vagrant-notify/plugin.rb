module Vagrant
  module Notify
    class Plugin < Vagrant.plugin('2')
      name 'vagrant notify'
      description 'Forwards notify-send from guest to host machine'

      action_hook 'notify-provisioning-status', :provisioner_run do |hook|
        require_relative './action'
        hook.before :run_provisioner, Vagrant::Notify::Action::NotifyProvisioningStatus
      end

      # TODO: This should be generic, we don't want to hard code every single
      #       possible provider action class that Vagrant might have
      start_server_hook = lambda do |hook|
        require_relative './action'
        hook.after VagrantPlugins::ProviderVirtualBox::Action::WaitForCommunicator, Vagrant::Notify::Action.action_start_server

        if defined?(Vagrant::LXC)
          require 'vagrant-lxc/action'
          hook.after Vagrant::LXC::Action::Boot, Vagrant::Notify::Action.action_start_server
        end
      end

      action_hook 'start-server-after-boot-on-machine-up',     :machine_action_up, &start_server_hook
      action_hook 'start-server-after-boot-on-machine-reload', :machine_action_reload, &start_server_hook

      share_folder_hook = lambda do |hook|
        require_relative './action'
        hook.after Vagrant::Action::Builtin::Provision, Vagrant::Notify::Action::SetSharedFolder
      end
      action_hook 'set-shared-folder-and-start-notify-server-on-machine-up',     :machine_action_up, &share_folder_hook
      action_hook 'set-shared-folder-and-start-notify-server-on-machine-reload', :machine_action_reload, &share_folder_hook

      action_hook 'stop-server-after-halt', :machine_action_halt do |hook|
        require_relative './action'
        hook.before Vagrant::Action::Builtin::GracefulHalt, Vagrant::Notify::Action.action_stop_server
      end

      # TODO: This should be generic, we don't want to hard code every single
      #       possible provider action class that Vagrant might have
      action_hook 'stop-server-before-destroy', :machine_action_destroy do |hook|
        require_relative './action'
        hook.before VagrantPlugins::ProviderVirtualBox::Action::Destroy, Vagrant::Notify::Action.action_stop_server

        if defined?(Vagrant::LXC)
          require 'vagrant-lxc/action'
          hook.before Vagrant::LXC::Action::Destroy, Vagrant::Notify::Action.action_stop_server
        end
      end
    end
  end
end
