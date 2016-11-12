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

You can use the freeware application [notify-send for Windows](http://vaskovsky.net/notify-send/), make sure the notify-send binary is available on `Path`. Or you can create your own notify-send program and compile it to an .exe binary executable.


Compile using ocra:

    ocra --output notify-send examples/windows/snarl/notify-send.rb


* [Growl for Windows wrapper script](https://github.com/fgrehm/vagrant-notify/blob/master/examples/windows/growl_for_windows/notify-send.rb) (`growlnotify.exe` needs to be is in your `Path`.)
* [Snarl wrapper script](https://github.com/fgrehm/vagrant-notify/blob/master/examples/windows/snarl/notify-send.rb)

### Windows 10

You can use our [wrapper script](https://github.com/fgrehm/vagrant-notify/blob/master/examples/windows/notification-center/notify-send.ps1) to send messages to the native Windows 10 notification center.

Compile using [PS1toEXE](https://github.com/aravindvcyber/PS1toEXE):

    ps c:> .\PS1toEXE.ps1 -inputfile examples/windows/notification-center/notify-send.ps1 notify-send.exe


* [Notification Center](https://github.com/fgrehm/vagrant-notify/blob/master/examples/windows/notification-center/notify-send.ps1)
