module Vagrant
  module Notify
    class Server
      HTTP_RESPONSE = "Hi! You just reached the vagrant notification server"

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

      def initialize(uuid, env = Vagrant::Environment.new)
        @uuid = uuid
        @env  = env
      end

      def receive_data(client)
        args = read_args(client)
        if http_request?(args)
          client.puts HTTP_RESPONSE
        else
          download_icon!(args)
          system("notify-send #{args}")
        end
        client.close
      end

      private

      def read_args(client)
        ''.tap do |args|
          while tmp = client.gets and tmp !~ /^\s*$/
            args << tmp
          end
        end
      end

      def http_request?(args)
        args =~ /^GET/
      end

      def download_icon!(args)
        return unless args =~ /-i '([^']+)'/
        icon = $1
        # TODO: Handle system icons
        host_file = "/tmp/vagrant-notify-#{@uuid}-#{icon.gsub('/', '-')}"
        @env.vms[:default].channel.download(icon, host_file) unless File.exists?(host_file)
        args.gsub!(icon, host_file)
      end
    end
  end
end
