## [0.5.6](https://github.com/fgrehm/vagrant-notify/compare/v0.5.5...v0.5.6) (September 29, 2017)
IMPROVEMENTS

  - AppleScript wrapper script.

BUG FIXES

  - `vagrant resume` bug fix. [[GH-39]](https://github.com/fgrehm/vagrant-notify/issues/39)

## [0.5.5](https://github.com/fgrehm/vagrant-notify/compare/v0.5.4...v0.5.5) (May 13, 2017)
IMPROVEMENTS

  - Support for Hyper-V and VMWare Workstation providers. [[GH-32]](https://github.com/fgrehm/vagrant-notify/issues/32) [[GH-33]](https://github.com/fgrehm/vagrant-notify/issues/33)
  - Disable plugin for google, vultr, vcloudair, skytap, and scaleway cloud providers.

BUG FIXES
  - Notifcation server suspend fix on VMWare Fusion.

## [0.5.4](https://github.com/fgrehm/vagrant-notify/compare/v0.5.3...v0.5.4) (May 4, 2017)
IMPROVEMENTS

  - Display warning if Ruby is not installed on guest. [[GH-35]](https://github.com/fgrehm/vagrant-notify/issues/35)
  - Shell name included in provision notify message. [[GH-21]](https://github.com/fgrehm/vagrant-notify/issues/21)

## [0.5.3](https://github.com/fgrehm/vagrant-notify/compare/v0.5.2...v0.5.3) (November 18, 2016)
IMPROVEMENTS

  - Command line operations work on multi-VM configurations.
  - Notification when provisioning fails. [[GH-23]](https://github.com/fgrehm/vagrant-notify/issues/23)
  - Do not start notification server if the guest is not running or has not been created.
  - New Windows 10 notify-send notification center PowerShell script.

BUG FIXES

  - Correctly identify guest shared folder capability. [[GH-31]](https://github.com/fgrehm/vagrant-notify/issues/31)
  - Properly manually restart notification server.
  - Don't send notify-send notices to host when doing a provision if plugin is disabled.


## [0.5.2](https://github.com/fgrehm/vagrant-notify/compare/v0.5.1...v0.5.2) (October 7, 2016)
IMPROVEMENTS

  - Support for docker, lxc, parallels, and vmware fusion providers. [[GH-13]](https://github.com/fgrehm/vagrant-notify/issues/13)
  - More reliable notification server status notices.
  - New `bind_ip` configuration option.

BUG FIXES

  - `vagrant destroy` on a running guest will now also stop the notfication server.


## [0.5.1](https://github.com/fgrehm/vagrant-notify/compare/v0.5.0...v0.5.1) (July 23, 2016)
IMPROVEMENTS

  - New config option to disable plugin. [[GH-6]](https://github.com/fgrehm/vagrant-notify/issues/6)
  - Plugin will automatically be disabled for cloud providers. [[GH-15]](https://github.com/fgrehm/vagrant-notify/issues/15)
  - Solaris 11 and BSD guests are now supported.
  - Windows snarl wrapper script.
  - OS X growlnotify 1.2.2 wrapper script.

BUG FIXES

  - All single quotes that are part of the title or message get removed.

## [0.5.0](https://github.com/fgrehm/vagrant-notify/compare/v0.4.0...v0.5.0) (June 21, 2016)

IMPROVEMENTS

  - Notification server runs as a daemon (fork() has been removed so it's compatible with Windows). [[GH-14]]
  - Windows support (beta) [[GH-14]]
  - Notification server is only available to localhost.
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
