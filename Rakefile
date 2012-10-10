require "bundler/gem_tasks"

require 'rspec/core/rake_task'
namespace :spec do
  RSpec::Core::RakeTask.new do |t|
    t.name = "unit"
    t.pattern = "spec/unit/**/*_spec.rb"
  end
end
