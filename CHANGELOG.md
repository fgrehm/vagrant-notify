

## [0.5.0](https://github.com/fgrehm/vagrant-notify/compare/v0.4.0...v0.5.0) (May 11, 2016)

IMPROVEMENTS

  - Notification server runs as a daemon (fork() has been removed so it's compatible with Windows). [[GH-14]]
  - Windows support (beta) [[GH-14]]
  - Notification server information is displayed each time vagrant is started and halted.
  - New plugin command. Ability to view notification server status, and ability for manual restart. [CLI](https://gist.github.com/alpha01/9b81caca694a2735e658f978c41600b5)
  - New notify-send example scripts for OS X and Windows

BUG FIXES

  - `vagrant suspend/resume` stops/starts notification server respectively. [[GH-18]]
  - Plugin causes VM boot to fail. [[GH-22]]

[GH-14]:https://github.com/fgrehm/vagrant-notify/issues/14
[GH-18]:https://github.com/fgrehm/vagrant-notify/issues/18
[GH-22]:https://github.com/fgrehm/vagrant-notify/pull/22


## [0.4.0](https://github.com/fgrehm/vagrant-notify/compare/v0.3.0...v0.4.0) (Feb 26, 2014)

IMPROVEMENTS

  - Notify provisioning status on Vagrant 1.4+ [[GH-5]]
  - Make use of `$SSH_CLIENT` when identifying host's IP to connect

BUG FIXES

  - Fix "rm: cannot remove ‘/usr/bin/notify-send’: No such file or directory" [[GH-11]]

## Previous

The changelog began with version 0.4.0 so any changes prior to that
can be seen by checking the tagged releases and reading git commit
messages.


[GH-5]:https://github.com/fgrehm/vagrant-notify/issues/5
[GH-11]:https://github.com/fgrehm/vagrant-notify/issues/11
