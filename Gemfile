source 'https://rubygems.org'

# Specify your gem's dependencies in vagrant-notify.gemspec
gemspec

group :development do
  gem 'rb-inotify'
  gem 'guard'
  gem 'guard-rspec'
end

group :development, :test do
  # We depend on Vagrant for development, but we don't add it as a
  # gem dependency because we expect to be installed within the
  # Vagrant environment itself using `vagrant plugin`.
  gem 'vagrant', github: 'mitchellh/vagrant'
  gem 'rake'
  gem 'rspec'
  gem 'rspec-spies'
end
