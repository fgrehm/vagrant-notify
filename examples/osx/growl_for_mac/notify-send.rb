#!/usr/bin/env ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Example OS X growlnotify 1.2.2 notify-send wrapper script.

require 'optparse'


options = {}
OptionParser.new do |opts|
  opts.on('-u', '--urgency LEVEL')           { |v| options[:u] = v } # TO DO: set to --priority
  opts.on('-t', '--expire-time TIME')        { |v| options[:t] = v } # Option gets removed
  opts.on('-a', '--app-name APP_NAME')       { |v| options[:a] = v } # Set to --name 
  opts.on('-i', '--icon ICON[,ICON...]')     { |v| options[:i] = v } # Set to --image
  opts.on('-c', '--category TYPE[,TYPE...]') { |v| options[:c] = v } # Option gets removed
  opts.on('-h', '--hint TYPE:NAME:VALUE')    { |v| options[:h] = v } # Option gets removed
  opts.on('-v', '--version')                 { |v| options[:v] = v } # Option gets removed
end.parse!


if ARGV.length == 0
  puts "No summary specified"
  exit 1
elsif ARGV.length == 1
  message = "--message '#{ARGV[0]}'"
  message << " --name #{options[:a]}" if options.include?(:a) 
  message << " --image #{options[:i]}" if options.include?(:i)
elsif ARGV.length == 2
  message = "--title '#{ARGV[0]}' --message '#{ARGV[1]}'"
  message << " --name #{options[:a]}" if options.include?(:a)
  message << " --image #{options[:i]}" if options.include?(:i)
else
  puts "Invalid number of options."
  exit 1
end

system("growlnotify #{message} 2>/dev/null")
