require 'vagrant'
require 'eventmachine'

require 'vagrant-notify/middleware'
require 'vagrant-notify/server'
require "vagrant-notify/version"

Vagrant.actions[:start].insert_before(Vagrant::Action::VM::Provision, Vagrant::Notify::Middleware::StartServer)
