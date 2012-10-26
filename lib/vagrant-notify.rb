require 'vagrant'
require 'socket'
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

Vagrant.actions[:start].tap do |start|
  start.use          Vagrant::Notify::Middleware::StartServer
  start.insert_after Vagrant::Action::VM::Boot, Vagrant::Notify::Middleware::InstallCommand
end
Vagrant.actions[:halt].use Vagrant::Notify::Middleware::StopServer
Vagrant.actions[:provision].use Vagrant::Notify::Middleware::InstallCommand
