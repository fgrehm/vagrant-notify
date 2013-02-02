# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-notify/version'

Gem::Specification.new do |gem|
  gem.name          = "vagrant-notify"
  gem.version       = Vagrant::Notify::VERSION
  gem.authors       = ["Fabio Rehm"]
  gem.email         = ["fgrehm@gmail.com"]
  gem.description   = 'A Vagrant plugin that redirects system notifications from guest to host machine.'
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/fgrehm/vagrant-notify"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'vagrant'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rspec-spies'
end
