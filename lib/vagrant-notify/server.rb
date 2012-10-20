module Vagrant
  module Notify
    module Server
      def post_init
        puts "-- someone connected to the server!"
      end

      def receive_data(data)
        `notify-send #{data}`
      end

      def self.run
        require 'eventmachine'

        EventMachine::run {
          # TODO: Add configuration for which port to use
          EventMachine::start_server "127.0.0.1", 8081, self
        }
      end
    end
  end
end
