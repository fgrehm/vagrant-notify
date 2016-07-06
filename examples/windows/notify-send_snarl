#!/usr/bin/env ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Example MS-Windows Snarl SNP/HTTP notify-send wrapper script.

require 'optparse'
require 'uri'
require "net/http"


options = {}
OptionParser.new do |opts|
  opts.on('-u', '--urgency LEVEL')           { |v| options[:u] = v } # TO DO: set to priority
  opts.on('-t', '--expire-time TIME')        { |v| options[:t] = v } # Set to timeout (notify-send milliseconds to snarl seconds)
  opts.on('-a', '--app-name APP_NAME')       { |v| options[:a] = v } # Option gets removed
  opts.on('-i', '--icon ICON[,ICON...]')     { |v| options[:i] = v } # Option gets removed (Snarl does not properly handle masked git-bash/cygwin absoute paths)
  opts.on('-c', '--category TYPE[,TYPE...]') { |v| options[:c] = v } # Option gets removed
  opts.on('-h', '--hint TYPE:NAME:VALUE')    { |v| options[:h] = v } # Option gets removed
  opts.on('-v', '--version')                 { |v| options[:v] = v } # Option gets removed
end.parse!


if ARGV.length == 0
  puts "No summary specified"
  exit 1
elsif ARGV.length == 1
  message = "notify?text='#{ARGV[0]}'"
  message << "&timeout=#{options[:t].to_i / 1000}'" if options.include?(:t)
elsif ARGV.length == 2
  message = "notify?title='#{ARGV[0]}'&text='#{ARGV[1]}'"
  message << "&timeout=#{options[:t].to_i / 1000}'" if options.include?(:t)
else
  puts "Invalid number of options."
  exit 1
end

enc_uri = URI.escape(message)
uri = URI.parse("http://127.0.0.1/#{enc_uri}")
#puts uri

Net::HTTP.get_response(uri)


