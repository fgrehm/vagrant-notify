module Vagrant
  module Notify
    class Server
      def initialize(uuid)
        @uuid = uuid
      end

      def receive_data(client)
        args = ''
        while tmp = client.gets
          args << tmp
        end
        client.close

        system("notify-send #{args}")
      end

      def self.run(env)
        uuid = env[:vm].uuid
        fork do
          $0 = 'vagrant-notify-server'
          tcp_server = TCPServer.open(Vagrant::Notify::server_port)
          server = self.new(uuid)
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
