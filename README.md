# vagrant-notify

[![Build Status](https://travis-ci.org/fgrehm/vagrant-notify.png)](https://travis-ci.org/fgrehm/vagrant-notify)
[![Gem Version](https://badge.fury.io/rb/vagrant-notify.png)](http://badge.fury.io/rb/vagrant-notify)

A Vagrant plugin that forwards `notify-send` from guest to host machine and
notifies provisioning status. [See it in action](#demo)


## Installation

Make sure you have Vagrant 1.4+ around and run:

```terminal
$ vagrant plugin install vagrant-notify
```


## Usage

### `notify-send` from guest VMs

Whenever you run `vagrant up`, a Ruby [TCPServer](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/socket/rdoc/TCPServer.html)
will fire up on a port within the [usable port range](https://www.vagrantup.com/docs/vagrantfile/machine_settings.html)
and a Ruby [script](https://github.com/fgrehm/vagrant-notify/blob/master/files/notify-send.erb)
will be copied over to the guest machine to replace the original `notify-send`
command.

### Provisioning notification

Apart from redirecting `notify-send` from the guest VM to the host, whenever
a Vagrant 1.4+ provisioner starts or completes running you'll also receive
notifications like:

![provisioning](http://i.imgur.com/DgKjDgr.png)

![provisioned](http://i.imgur.com/UGhOAzV.png)

### Linux

Since Linux distributions have `notify-send` pre-installed, everything should work out of the box.

### OS X

Check out our OS X notify-send compatible [scripts](https://github.com/fgrehm/vagrant-notify/tree/master/examples#os-x).

### Windows

Check out our Windows notify-send compatible [scripts](https://github.com/fgrehm/vagrant-notify/tree/master/examples#windows).

## Configuration

Notification server is enabled by default on all guests. You can individually disable the plugin by adding a false boolean to the ***notify.enable*** option in your `Vagrantfile` configuration block

```ruby
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.notify.enable = false
end
```

_Please note that as of v0.5.1, the notification server will automatically be disabled for any of the following
[cloud providers](lib/vagrant-notify/plugin.rb#L81-L83)._

By default, the notification server is binded to [local interfaces](lib/vagrant-notify/plugin.rb#L86-L93). For networking different than your provider's default network configuration, you can use the ***notify.bind\_ip*** configuration option to bind the notification server onto a different local ip address. 

```ruby
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.notify.bind_ip = "192.68.56.20"
end
```

By default local server uses ***notify_send*** command for displaying notifications, there is a possibility to use different app without wrapper scripts: 
* ***notify.sender\_app*** configuration option is used for specifing application name (default: `notify-send`)
* ***notify.sender\_params\_str*** defines how params for applications will be passed (default: `[--app-name {app_name}] [--urgency {urgency}] [--expire-time {expire_time}] [--icon {icon}] [--category {category}] [--hint {hint}] {message}`). You can use these variables (escaped by `{` and `}` characters) here:
  * ***urgency*** - urgency level for notification
  * ***expire\_time*** - when notification will expire?
  * ***app\_name*** - application name
  * ***icon*** - icon for the notification (can be multiple, devided by comma)
  * ***category*** - category for the notification (can be multiple, devided by comma)
  * ***hint*** - icon for the notification (need to use this format: TYPE:NAME:VALUE)
  * ***message*** - message to send
* ***notify.sender\_params\_escape*** - should params will be escaped when passed to script (default: `true`)

This is example how to to run notifications with build-in MacOS X notifications support:
```ruby
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.notify.sender_params_str = '-e \'display notification {message} sound name \"default\"\''
  config.notify.sender_app = 'osascript'
  config.notify.sender_params_escape = true
end
```

**WARNING**

_Do **NOT** bind the notification server to an IP accessible over a network! The notification server does not have any authentication and doing so will leave your system vulnerable to remote command execution._

### Providers and Guests

vagrant-notify supports the following providers:

  - VirtualBox
  - Docker
  - Hyper-V
  - [LXC](https://github.com/fgrehm/vagrant-lxc)
  - [Parallels](https://github.com/Parallels/vagrant-parallels)
  - [VMWare Fusion](https://www.vagrantup.com/vmware)
  - [VMWare Workstation](https://www.vagrantup.com/vmware)

vagrant-notify has been tested and known to work with Linux, Solaris 11, FreeBSD, OpenBSD, and NetBSD guests. (notify-send icon forwarding feature is not supported on BSD guests)

## Demo

![Demo](http://i.imgur.com/tzOLvGY.gif)
![Demo OS X](http://i.imgur.com/216NIlf.gif)
![Demo Windows](http://i.imgur.com/cJYqX4y.gif)


## Known issues

* On rare occasions the notification server may stop receiving notifications if the host is suspended/hibernates. The notification server may need to be manually restarted if that's the case. `vagrant notify --restart`


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
