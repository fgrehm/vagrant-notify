module Vagrant
  module Notify
    class Plugin < Vagrant.plugin('2')
      name 'vagrant notify'
      description 'Forwards notify-send from guest to host machine'

      # TODO: This should be generic, we don't want to hard code every single
      #       possible provider action class that Vagrant might have
      action_hook 'start-server-after-boot' do |hook|
        require_relative './action'
        hook.after VagrantPlugins::ProviderVirtualBox::Action::Boot, Vagrant::Notify::Action.action_start_server

        if defined?(Vagrant::LXC)
          require 'vagrant-lxc/action'
          hook.after Vagrant::LXC::Action::Boot, Vagrant::Notify::Action.action_start_server
        end
      end

      share_folder_hook = lambda do |hook|
        require_relative './action'
        hook.after Vagrant::Action::Builtin::Provision, Vagrant::Notify::Action::SetSharedFolder
      end
      action_hook 'set-shared-folder-and-start-notify-server-on-machine-up',     :machine_action_up, &share_folder_hook
      action_hook 'set-shared-folder-and-start-notify-server-on-machine-reload', :machine_action_reload, &share_folder_hook

      action_hook 'stop-server-after-halt' do |hook|
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
