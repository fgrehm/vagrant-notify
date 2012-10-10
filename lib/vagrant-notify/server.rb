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
          EventMachine::start_server "127.0.0.1", 8081, self
          puts 'running echo server on 8081'
        }
      end
    end
  end
end
