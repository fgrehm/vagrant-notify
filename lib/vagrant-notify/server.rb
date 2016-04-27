require 'socket'

module Vagrant
  module Notify
    class Server
      HTTP_RESPONSE = "Hi! You just reached the vagrant notification server"

      def self.run(id, port, machine_name='default', provider='virtualbox')
        #id           = env[:machine].id
        #machine_name = env[:machine].name
        #provider     = env[:machine].provider_name

 
        $0 = "vagrant-notify-server (#{port})"
        tcp_server = TCPServer.open("127.0.0.1", port)
        server = self.new(id, machine_name, provider)

        # Have to wrap this in a begin/rescue block so we can be certain the server is running at all times.
        begin 
          loop {
                Thread.start(tcp_server.accept) { |client|
                  Thread.handle_interrupt(Interrupt => :never) {  
                  server.receive_data(client)
                  }
              }
            }
        rescue Interrupt
          retry
        end
          
      end

      def initialize(id, machine_name = :default, provider = :virtualbox)
        @id           = id
        @machine_name = machine_name
        @provider     = provider
      end

      def receive_data(client)
        args = read_args(client)
        if http_request?(args)
          client.puts HTTP_RESPONSE
        else
          fix_icon_path!(args)
          if RUBY_PLATFORM =~ /mswin|msys|mingw|cygwin|bccwin|wince|emc/
            notify_send = ENV["NOTIFY_SEND"]
            if notify_send.nil?
              log "NOTIFY_SEND environment variable is not set."
            else
              system("ruby #{notify_send} #{args}")
            end
          else
            system("notify-send #{args}")
          end
        end
        client.close
      rescue => ex
        log ex.message
      end

      private

      def log(message)
        File.open("/tmp/vagrant-notify-error-#{@id}.log", 'a+') do |log|
          log.puts "#{message}"
        end
      end

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

      def fix_icon_path!(args)
        return unless args =~ /-i '([^']+)'/
        icon = $1
        # TODO: Handle system icons
        host_file = "/tmp/vagrant-notify/#{@id}/#{icon.gsub('/', '-')}"
        args.gsub!(icon, host_file)
      end
    end
  end
end


# Ghetto
id = ARGV[0]
port = ARGV[1]

Vagrant::Notify::Server.run(id,port)