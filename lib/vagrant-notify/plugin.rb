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
          # TODO: Require just the boot action file once its "require dependencies" are sorted out
          require 'vagrant-lxc/action'
          hook.after Vagrant::LXC::Action::Boot, Vagrant::Notify::Action.action_start_server
        end
      end

      action_hook 'install-command-after-provisioning', :machine_action_provision do |hook|
        hook.after Vagrant::Action::Builtin::Provision, Vagrant::Notify::Action.action_start_server
      end

      action_hook 'stop-server-after-halting', :machine_action_halt do |hook|
        require_relative './action'
        hook.before Vagrant::Action::Builtin::GracefulHalt, Vagrant::Notify::Action.action_stop_server
      end

      # TODO: This should be generic, we don't want to hard code every single
      #       possible provider action class that Vagrant might have
      action_hook 'stop-server-before-destruction', :machine_action_destroy do |hook|
        require_relative './action'
        hook.before VagrantPlugins::ProviderVirtualBox::Action::Destroy, Vagrant::Notify::Action.action_stop_server

        if defined?(Vagrant::LXC)
          # TODO: Require just the destroy action file once its "require dependencies" are sorted out
          require 'vagrant-lxc/action'
          hook.before Vagrant::LXC::Action::Destroy, Vagrant::Notify::Action.action_stop_server
        end
      end
    end
  end
end
