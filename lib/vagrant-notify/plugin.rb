module Vagrant
  module Notify
    class Plugin < Vagrant.plugin('2')
      name 'vagrant notify'
      description 'Forwards notify-send from guest to host machine'
    end
  end
end
