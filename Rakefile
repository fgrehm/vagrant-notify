require "bundler/gem_tasks"

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new do |t|
  t.pattern = "spec/**/*_spec.rb"
end

desc 'Outpus some information about Vagrant middleware stack useful for development (use ACTION=action_name to filter out actions)'
task 'vagrant-stack' do
  require 'vagrant'
  Vagrant.actions.to_hash.each do |action, stack|
    next unless !ENV['ACTION'] || ENV['ACTION'] == action.to_s

    puts action
    stack.send(:stack).each do |middleware|
      puts "  #{middleware[0]}"
      puts "    -> #{middleware[1].inspect}" unless middleware[1].empty?
    end
  end
end

task :default => :spec
