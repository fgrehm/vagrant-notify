Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.synced_folder "../", "/vagrant", id: 'vagrant-root'

  config.notify.enable = true
  config.notify.sender_params_str = '-e \'display notification {message} sound name \"default\"\''
  config.notify.sender_app = 'osascript'
  config.notify.sender_params_escape = true
end