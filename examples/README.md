# Example notify-send wrapper scripts

## OS X

* [terminal-notifier](https://github.com/alloy/terminal-notifier) [wrapper script](https://github.com/fgrehm/vagrant-notify/blob/master/examples/osx/notify-send_terminal-notifier) 
* [growlnotify](http://growl.info/downloads) [wrapper script](https://github.com/fgrehm/vagrant-notify/blob/master/examples/osx/notify-send_growl_for_mac)


## Windows

* [Growl for Windows](http://www.growlforwindows.com/gfw/default.aspx) [wrapper script](https://github.com/fgrehm/vagrant-notify/blob/master/examples/windows/notify-send_growl_for_windows)

**IMPORTANT:** `notify-send` wrapper script has to be binary executable. Also as with `notify-send`, `growlnotify.exe` needs to be is in your `path`. 

Compiling using ocra:

    ocra --output notify-send windows/notify-send_growl_for_windows