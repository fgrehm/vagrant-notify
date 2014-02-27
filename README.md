# vagrant-notify

[![Build Status](https://travis-ci.org/fgrehm/vagrant-notify.png)](https://travis-ci.org/fgrehm/vagrant-notify)
[![Gem Version](https://badge.fury.io/rb/vagrant-notify.png)](http://badge.fury.io/rb/vagrant-notify)
[![Gittip](http://img.shields.io/gittip/fgrehm.svg)](https://www.gittip.com/fgrehm/)

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

## Demo

![Demo](http://i.imgur.com/tzOLvGY.gif)


## Known issues

* `vagrant suspend` does not stop the notification server


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
