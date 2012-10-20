module Vagrant
  module Notify
    module Server
      def receive_data(data)
        `notify-send #{data}`
      end

      def self.run
        require 'eventmachine'
        fork do
          $0 = 'vagrant-notify-server'
          EventMachine::run {
            # TODO: Add configuration for which port to use
            EventMachine::start_server "127.0.0.1", 8081, self
          }
        end
      end
    end
  end
end
