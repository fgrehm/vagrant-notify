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
will fire up on a port within the [usable port range](https://github.com/mitchellh/vagrant/blob/master/config/default.rb#L14)
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

You will need to create a `notify-send` script, available on `$PATH`. The script can forward the message to either
[Growl](http://growl.info/) with [GrowlNotify](http://growl.info/downloads) (version 1.2.2 is free but unreliable)
or to the [Notification Center](http://support.apple.com/kb/HT5362) available on OS X 10.8+
using f.ex. [terminal-notifier](https://github.com/alloy/terminal-notifier).

A (too) primitive script integrating with Growl:

```bash
#!/bin/bash
growlnotify -t "Vagrant VM" -m "$*"
```

Check out our OS X notify-send compatible [scripts](https://github.com/fgrehm/vagrant-notify/tree/master/examples#os-x).

### Windows (beta)

You can use the freeware application [notify-send for Windows](http://vaskovsky.net/notify-send/), make sure the notify-send binary is available on `Path`.

Check out our Windows notify-send compatible [scripts](https://github.com/fgrehm/vagrant-notify/tree/master/examples#windows).

## Configuration

Notification server is enabled by default on all guests. You can individually disable the plugin by adding the following to your `Vagrantfile`

```ruby
config.notify.enable = false
```

_Please note that as of v0.5.1, the notification server will automatically be disabled for any of the following
[cloud providers](lib/vagrant-notify/plugin.rb#L77-L79)._

By default, the notification server is binded to [local interfaces](lib/vagrant-notify/plugin.rb#L82-L86). For networking different than your provider's default network configuration, you can use the *bind_ip* configuration option to bind the notification server onto a different local ip address. 

```ruby
config.notify.bind_ip = "192.68.56.20"
```

**WARNING**

_Do **NOT** bind the notification server to an IP accessible over a network! The notification server does not have any authentication and doing so will leave your system vulnerable to remote command execution._

### Providers and Guests

vagrant-notify supports the following providers:

  - VirtualBox
  - Docker
  - [LXC](https://github.com/fgrehm/vagrant-lxc)
  - [Parallels](https://github.com/Parallels/vagrant-parallels)
  - [VMWare Fusion](https://www.vagrantup.com/vmware)

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
