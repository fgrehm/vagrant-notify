#!/usr/bin/env ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Example OS X terminal-notifier notify-send wrapper script.

require 'optparse'


options = {}
OptionParser.new do |opts|
  opts.on('-u', '--urgency LEVEL')           { |v| options[:u] = v } # Option gets removed
  opts.on('-t', '--expire-time TIME')        { |v| options[:t] = v } # Option gets removed
  opts.on('-a', '--app-name APP_NAME')       { |v| options[:a] = v } # TO DO: Set to -title
  opts.on('-i', '--icon ICON[,ICON...]')     { |v| options[:i] = v } # Option gets removed
  opts.on('-c', '--category TYPE[,TYPE...]') { |v| options[:c] = v } # Option gets removed
  opts.on('-h', '--hint TYPE:NAME:VALUE')    { |v| options[:h] = v } # Option gets removed
  opts.on('-v', '--version')                 { |v| options[:v] = v } # Option gets removed
end.parse!


if ARGV.length == 0
  puts "No summary specified"
  exit 1
elsif ARGV.length == 1
  message = "-message '\\#{ARGV[0]}'"
elsif ARGV.length == 2
  message = "-title '\\#{ARGV[0]}' -message '\\#{ARGV[1]}'"
else
  puts "Invalid number of options."
  exit 1
end

system("terminal-notifier -sound default #{message}")
