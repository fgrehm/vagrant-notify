module Vagrant
  module Notify
    class Plugin < Vagrant.plugin('2')
      name 'vagrant notify'
      description 'Forwards notify-send from guest to host machine'

      action_hook 'start-server-after-provisioning' do |hook|
        require_relative './action'
        hook.after Vagrant::Action::Builtin::Provision, Vagrant::Notify::Action.action_start_server
      end
    end
  end
end
