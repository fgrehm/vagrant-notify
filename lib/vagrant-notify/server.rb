module Vagrant
  module Notify
    class Server
      def receive_data(client)
        args = ''
        while tmp = client.gets
          args << tmp
        end
        client.close

        system("notify-send #{args}")
      end

      def self.run
        fork do
          $0 = 'vagrant-notify-server'
          # TODO: Add configuration for which port to use
          tcp_server = TCPServer.open(8081)
          server = self.new
          loop {
            Thread.start(tcp_server.accept) do |client|
              server.receive_data(client)
            end
          }
        end
      end
    end
  end
end
