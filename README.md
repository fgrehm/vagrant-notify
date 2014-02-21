# vagrant-notify

[![Build Status](https://travis-ci.org/fgrehm/vagrant-notify.png)](https://travis-ci.org/fgrehm/vagrant-notify)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/fgrehm/vagrant-notify)
[![Gem Version](https://badge.fury.io/rb/vagrant-notify.png)](http://badge.fury.io/rb/vagrant-notify)
[![Gittip](http://img.shields.io/gittip/fgrehm.svg)](https://www.gittip.com/fgrehm/)

A Vagrant plugin that forwards `notify-send` from guest to host machine, tested
using Ubuntu as guest and host machine.

## Installation

Make sure you have Vagrant >= 1.1 around and run:

```terminal
$ vagrant plugin install vagrant-notify
```


## Usage

Whenever you run `vagrant up`, a Ruby [TCPServer](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/socket/rdoc/TCPServer.html)
will fire up on a port within the [usable port range](https://github.com/mitchellh/vagrant/blob/master/config/default.rb#L14)
and a [script](https://github.com/fgrehm/vagrant-notify/blob/master/files/notify-send.erb)
will be copied over to the guest machine to replace the original `notify-send`
command.

If by any chance your IP changes, you can run `vagrant provision` in order to
update the guest script with the new IP.

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

## Known issues

* `vagrant suspend` does not stop the notification server


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
