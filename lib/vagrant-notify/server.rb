module Vagrant
  module Notify
    class Server
      def initialize(uuid, env = Vagrant::Environment.new)
        @uuid = uuid
        @env  = env
      end

      def receive_data(client)
        args = ''
        while tmp = client.gets and tmp !~ /^\s*$/
          args << tmp
        end

        if args =~ /^GET/
          client.puts "Hi! You just reached the vagrant notification server"
          return client.close
        end

        client.close

        # TODO: Specs needed!
        if args =~ /-i '([^']+)'/
          image     = $1
          host_file = "/tmp/vagrant-notify-#{@uuid}-#{image.gsub('/', '-')}"
          # TODO: Download based on ID
          @env.vms[:default].channel.download(image, host_file) unless File.exists?(host_file)
          args.gsub!(image, host_file)
        end

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
