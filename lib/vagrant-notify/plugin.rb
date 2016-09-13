module Vagrant
  module Notify
    class Plugin < Vagrant.plugin('2')
      name 'vagrant notify'
      description 'Forwards notify-send from guest to host machine'

      action_hook 'notify-provisioning-status', :provisioner_run do |hook|
        require_relative './action'
        hook.before :run_provisioner, Vagrant::Notify::Action::NotifyProvisioningStatus
      end

      start_server_hook = lambda do |hook|
        require_relative './action'
        hook.after Vagrant::Action::Builtin::WaitForCommunicator, Vagrant::Notify::Action.action_start_server
      end

      action_hook 'start-server-after-boot-on-machine-up',     :machine_action_up, &start_server_hook
      action_hook 'start-server-after-boot-on-machine-reload', :machine_action_reload, &start_server_hook
      action_hook 'start-server-after-resume-on-machine',      :machine_action_resume, &start_server_hook

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

      action_hook 'stop-server-before-destroy', :machine_action_destroy do |hook|
        require_relative './action'
        hook.before Vagrant::Action::Builtin::DestroyConfirm, Vagrant::Notify::Action.action_stop_server
      end

      # There isn't a Vagrant Action Bulitin module for suspend operations.
      # Suspend class is implemented at the individual provider plugin level, therefore need to list them here.
      action_hook 'stop-server-after-suspend', :machine_action_suspend do |hook|
        require_relative './action'
        # Vagrant's default providers: (Docker does not suport suspend)
        hook.before VagrantPlugins::ProviderVirtualBox::Action::Suspend, Vagrant::Notify::Action.action_stop_server
        hook.before VagrantPlugins::HyperV::Action::SuspendVM, Vagrant::Notify::Action.action_stop_server

        # Third party provider plugins:
        if defined?(HashiCorp::VagrantVMwarefusion)
          require 'vagrant-parallels/action'
          hook.before HashiCorp::VagrantVMwarefusion::Action::Suspend, Vagrant::Notify::Action.action_stop_server
        end
        if defined?(VagrantPlugins::Parallels)
          require 'vagrant-parallels/action'
          hook.before VagrantPlugins::Parallels::Action::Suspend, Vagrant::Notify::Action.action_stop_server
        end
        if defined?(VagrantPlugins::AppCatalyst)
          require 'vagrant-vmware-appcatalyst/action'
          hook.before VagrantPlugins::AppCatalyst::Action::Suspend, Vagrant::Notify::Action.action_stop_server
        end
      end

      command(:notify) do
        require_relative 'command'
        Vagrant::Notify::Command
      end

      config(:notify) do
        require_relative 'config'
        Vagrant::Notify::Config
      end
    end
  end
 
  # Keep an eye on https://github.com/mitchellh/vagrant/wiki/Available-Vagrant-Plugins#wiki-providers for more.
  CLOUD_PROVIDERS = %w( aws cloudstack digital_ocean hp joyent openstack rackspace
                          softlayer proxmox managed azure brightbox cloudstack vcloud
                          vsphere )

  # Supported providers and default IPs used to bind the notifcation server too.
  SUPPORTED_PROVIDERS = { :virtualbox     => '127.0.0.1',
                          :lxc            => '10.0.3.1',
                          :parallels      => '10.211.55.2',
                          :vmware_fusion  => '192.168.172.1'
                        }
end
