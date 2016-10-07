require "vagrant/util/is_port_open"


module Vagrant
  module Notify
    module Action
      class StartServer
        include Util::IsPortOpen

        def initialize(app, env)
          @app = app
        end

        def call(env)
          @env = env

          id = env[:machine].id
          provider_name = env[:machine].provider_name
          dir = File.expand_path('../../', __FILE__)
          
          return if env[:machine].config.notify.enable == false

          port = next_available_port(env[:machine].config.notify.bind_ip)

          if which('ruby')
            env[:notify_data][:pid]  = Process.spawn("ruby #{dir}/server.rb #{id} #{port} #{env[:machine].config.notify.bind_ip} #{provider_name}")
            env[:notify_data][:port] = port

            sleep 5
            Process.detach(env[:notify_data][:pid].to_i)
          else
            env[:machine].ui.error("Unable to spawn TCPServer daemon, ruby not found in $PATH")
          end

          @app.call env

        end

        def next_available_port(bind_ip)
          # Determine a list of usable ports for us to use
          usable_ports = Set.new(@env[:machine].config.vm.usable_port_range)

          # Pass one, remove all defined host ports from usable ports
          with_forwarded_ports do |options|
            usable_ports.delete(options[:host])
          end

          # Pass two, remove ports used by other processes
          with_forwarded_ports do |options|
            host_port = options[:host]
            usable_ports.delete(options[:host]) if is_port_open?(bind_ip, host_port)
          end

          # If we have no usable ports then we can't use the plugin
          raise 'No usable ports available!' if usable_ports.empty?

          # Set the port up to be the last one since vagrant's port collision handler
          # will use the first as in:
          #   https://github.com/mitchellh/vagrant/blob/master/lib/vagrant/action/builtin/handle_forwarded_port_collisions.rb#L84
          usable_ports.to_a.sort.reverse.find do |port|
            return port unless is_port_open?(bind_ip, port)
          end
        end

        def with_forwarded_ports
          @env[:machine].config.vm.networks.each do |type, options|
            # Ignore anything but forwarded ports
            next if type != :forwarded_port

            yield options
          end
        end

        # http://stackoverflow.com/questions/2108727/which-in-ruby-checking-if-program-exists-in-path-from-ruby
        # Cross-platform way of finding an executable in the $PATH.
        #   which('ruby') #=> /usr/bin/ruby
        def which(cmd)
          exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
          ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
            exts.each { |ext|
              exe = File.join(path, "#{cmd}#{ext}")
              return exe if File.executable?(exe) && !File.directory?(exe)
            }
          end
          return nil
        end
      end
    end
  end
end
