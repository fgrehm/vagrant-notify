module Vagrant
  module Notify
    class Server
      HTTP_RESPONSE = "Hi! You just reached the vagrant notification server"

      def self.run(env, port)
        id           = env[:machine].id
        communicator = env[:machine].communicate
        fork do
          $0 = "vagrant-notify-server (#{port})"
          tcp_server = TCPServer.open(port)
          server = self.new(id, communicator)
          loop {
            Thread.start(tcp_server.accept) { |client|
              begin
                server.receive_data(client)
              rescue => ex
                File.open("/tmp/vagrant-notify-error-#{id}.log", 'a') { |f| f.puts ex.message }
              end
            }
          }
        end
      end

      def initialize(id, communicator)
        @id           = id
        @communicator = communicator
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
        host_file = "/tmp/vagrant-notify-#{@id}-#{icon.gsub('/', '-')}"
        download(icon, host_file) unless File.exists?(host_file)
        args.gsub!(icon, host_file)
      end

      def download(icon, host_file)
        @communicator.download(icon, host_file)
      end
    end
  end
end
