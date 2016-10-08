# Example notify-send wrapper scripts

You will need to create a `notify-send` script, available on `$PATH`. 
A (too) primitive script integrating with Growl for OS X:

```bash
#!/bin/bash
growlnotify -t "Vagrant VM" -m "$*"
```


## OS X

The `notify-send` script can forward the message to either
[Growl](http://growl.info/) with [GrowlNotify](http://growl.info/downloads) (version 1.2.2 is free but unreliable)
or to the [Notification Center](http://support.apple.com/kb/HT5362) available on OS X 10.8+
using f.ex. [terminal-notifier](https://github.com/alloy/terminal-notifier).


* [terminal-notifier wrapper script](https://github.com/fgrehm/vagrant-notify/blob/master/examples/osx/notify-send_terminal-notifier) 
* [growlnotify wrapper script](https://github.com/fgrehm/vagrant-notify/blob/master/examples/osx/notify-send_growl_for_mac)


## Windows

**IMPORTANT:** In addition of a `notify-send` script being in your `path`, the `notify-send` wrapper script has to be an .exe binary executable.
Compiling using ocra:

    ocra --output notify-send windows/notify-send_growl_for_snarl


* [Growl for Windows wrapper script](https://github.com/fgrehm/vagrant-notify/blob/master/examples/windows/notify-send_growl_for_windows) (`growlnotify.exe` needs to be is in your `path`.)
* [Snarl wrapper script](https://github.com/fgrehm/vagrant-notify/blob/master/examples/windows/notify-send_snarl)