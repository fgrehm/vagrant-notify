require 'vagrant'
require 'socket'
require 'erb'
require 'ostruct'

if File.exists?(File.join(File.expand_path('../../', __FILE__), '.git'))
  $:.unshift(File.expand_path('../../lib', __FILE__))
end

require 'vagrant-notify/middleware'
require 'vagrant-notify/server'
# FIXME: This should be required based on Vagrant version installed, the new version
#        seems to include a method for downloading out of the box:
#           https://github.com/mitchellh/vagrant/blob/master/plugins/communicators/ssh/communicator.rb#L80
require 'vagrant-notify/vagrant_ssh_ext'
require "vagrant-notify/version"

module Vagrant
  module Notify
    class << self
      def server_port
        @@server_port ||= 8081
      end
      def server_port=(server_port)
        @@server_port = server_port
      end

      def files_path
        @file_path ||= File.expand_path(File.dirname(__FILE__) + '/../files')
      end
    end
  end
end

Vagrant.actions[:start].tap do |start|
  start.use          Vagrant::Notify::Middleware::StartServer
  start.insert_after Vagrant::Action::VM::Boot, Vagrant::Notify::Middleware::InstallCommand
end
Vagrant.actions[:halt].use Vagrant::Notify::Middleware::StopServer
Vagrant.actions[:provision].use Vagrant::Notify::Middleware::InstallCommand
