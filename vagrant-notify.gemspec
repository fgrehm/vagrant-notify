# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-notify/version'

Gem::Specification.new do |gem|
  gem.name          = "vagrant-notify"
  gem.version       = Vagrant::Notify::VERSION
  gem.authors       = ["Fabio Rehm", "Tony Baltazar"]
  gem.email         = ["fgrehm@gmail.com", "root@rubyninja.org"]
  gem.description   = 'A Vagrant plugin that forwards `notify-send` from guest to host machine and notifies provisioning status'
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/fgrehm/vagrant-notify"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
