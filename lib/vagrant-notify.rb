require 'vagrant'

require 'vagrant-notify/middleware'
require 'vagrant-notify/server'
require "vagrant-notify/version"

Vagrant.actions[:start].insert_after(Vagrant::Action::VM::Provision, Vagrant::Notify::Middleware)
