require 'vagrant'
require 'socket'
require 'erb'
require 'ostruct'

if File.exists?(File.join(File.expand_path('../../', __FILE__), '.git'))
  $:.unshift(File.expand_path('../../lib', __FILE__))
end

require 'vagrant-notify/server'
require "vagrant-notify/version"

module Vagrant
  module Notify
    class << self
      def files_path
        @file_path ||= File.expand_path(File.dirname(__FILE__) + '/../files')
      end
    end
  end
end
