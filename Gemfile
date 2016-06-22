source 'https://rubygems.org'

# Specify your gem's dependencies in vagrant-notify.gemspec
gemspec

group :development do
  gem 'rb-inotify'
  gem 'guard'
  gem 'guard-rspec'
  gem 'ocra'
end

group :development, :test do
  gem 'vagrant',     github: 'mitchellh/vagrant'
  gem 'vagrant-lxc', github: 'fgrehm/vagrant-lxc'
  gem 'rake'
  gem 'rspec',       '~> 2.13.0'
  gem 'rspec-spies'
end
