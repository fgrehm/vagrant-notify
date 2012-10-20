module Vagrant
  module Notify
    class Server < EventMachine::Connection
      def receive_data(data)
        system("notify-send #{data}")
      end

      def self.run
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
