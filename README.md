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
and a [script](https://github.com/fgrehm/vagrant-notify/blob/master/files/notify-send.erb)
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

Check out our OS X notify-send compatible [scripts](https://github.com/fgrehm/vagrant-notify/tree/master/examples).

### Windows (beta)

You can use the freeware application [notify-send for Windows](http://vaskovsky.net/notify-send/), make sure the notify-send binary is available on `Path`.

Check out our Windows notify-send compatible [scripts](https://github.com/fgrehm/vagrant-notify/tree/master/examples).

## Configuration

Notifcation server is enabled by default on all VMs. You can individually disable the plugin by adding the following to your `Vagrantfile`

```ruby
config.notify.enable = false
```

_Please note that as of v0.5.1, the notification server will automatically be disabled for any of the following
[cloud providers](lib/vagrant-notify/plugin.rb#L72-74)_

## Demo

![Demo](http://i.imgur.com/tzOLvGY.gif)
![Demo OS X](http://i.imgur.com/216NIlf.gif)
![Demo Windows](http://i.imgur.com/cJYqX4y.gif)


## Known issues

* `vagrant destroy` on a running VM will not stop the notification server.
* On rare occasions the notification server may stop receiving notifications if the host is suspended/hibernates. The notification server may need to be manually restarted if that's the case. `vagrant notify --restart`


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
