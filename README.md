# Vagrant::Notify

[![Build Status](https://travis-ci.org/fgrehm/vagrant-notify.png)](https://travis-ci.org/fgrehm/vagrant-notify)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/fgrehm/vagrant-notify)

A Vagrant plugin that forwards `notify-send` from guest to host machine, tested
using Ubuntu as guest and host machine.

## Installation

Add this line to your application's Gemfile:

    gem 'vagrant-notify'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vagrant-notify

## Usage

After installing the gem, whenever you run `vagrant up`, a Ruby
[TCPServer](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/socket/rdoc/TCPServer.html)
will fire up on `8081` port and a [script](https://github.com/fgrehm/vagrant-notify/blob/master/files/notify-send.erb)
will be installed on the guest machine to replace the original `notify-send`
command.

If by any chance your IP changes, you can run `vagrant provision` in order to
update the guest script with the new IP.

In case you need to run the notification server on a different port, you can set
it from your `Vagrantfile`:

```ruby
Vagrant::Notify::server_port = 8888
```



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
