require 'vagrant'
require 'eventmachine'
require 'erb'
require 'ostruct'

require 'vagrant-notify/middleware'
require 'vagrant-notify/server'
require "vagrant-notify/version"

module Vagrant
  module Notify
    def self.files_path
      @file_path ||= File.expand_path(File.dirname(__FILE__) + '/../files')
    end
  end
end

Vagrant.actions[:start].insert_before(Vagrant::Action::VM::Provision, Vagrant::Notify::Middleware::StartServer)
Vagrant.actions[:start].insert_after(Vagrant::Action::VM::Boot, Vagrant::Notify::Middleware::InstallCommand)

Vagrant.actions[:halt].insert_before(Vagrant::Action::VM::Halt, Vagrant::Notify::Middleware::StopServer)
