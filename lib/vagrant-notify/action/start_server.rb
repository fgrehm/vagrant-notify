require "vagrant/util/is_port_open"

require_relative '../server'

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

          port = next_available_port
          env[:notify_data][:pid]  = Server.run(env, port)
          env[:notify_data][:port] = port

          @app.call env
        end

        def next_available_port
          # Determine a list of usable ports for us to use
          usable_ports = Set.new(@env[:machine].config.vm.usable_port_range)

          # Pass one, remove all defined host ports from usable ports
          with_forwarded_ports do |options|
            usable_ports.delete(options[:host])
          end

          # Pass two, remove ports used by other processes
          with_forwarded_ports do |options|
            host_port = options[:host]
            usable_ports.delete(options[:host]) if is_port_open?("127.0.0.1", host_port)
          end

          # If we have no usable ports then we can't use the plugin
          raise 'No usable ports available!' if usable_ports.empty?

          # Set the port up to be the last one since vagrant's port collision handler
          # will use the first as in:
          #   https://github.com/mitchellh/vagrant/blob/master/lib/vagrant/action/builtin/handle_forwarded_port_collisions.rb#L84
          usable_ports.to_a.sort.reverse.find do |port|
            return port unless is_port_open?("127.0.0.1", port)
          end
        end

        def with_forwarded_ports
          @env[:machine].config.vm.networks.each do |type, options|
            # Ignore anything but forwarded ports
            next if type != :forwarded_port

            yield options
          end
        end
      end
    end
  end
end
