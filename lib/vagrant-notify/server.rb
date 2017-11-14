require 'socket'
require 'json'
require 'tmpdir'

module Vagrant
  module Notify
    class Server
      HTTP_RESPONSE = "Hi! You just reached the vagrant notification server"

      def self.run(id, port, bind_ip, sender_app, sender_params_str, sender_params_escape, machine_name='default', provider='virtualbox')
        #id                   = env[:machine].id
        #machine_name         = env[:machine].name
        #provider             = env[:machine].provider_name
        #sender_app           = env[:machine].config.sender_app
        #sender_params_str    = env[:machine].config.sender_params_str
        #sender_params_escape = env[:machine].config.sender_params_escape

        if __FILE__ == $0
          begin
            tcp_server = TCPServer.open(bind_ip, port)
          rescue
              exit 1
          end
          server = self.new(id, sender_app, sender_params_str, sender_params_escape, machine_name, provider)

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
      end

      def initialize(id, sender_app, sender_params_str, sender_params_escape, machine_name = :default, provider = :virtualbox)
        @id           = id
        @machine_name = machine_name
        @provider     = provider
        @sender_app = sender_app
        @sender_params_str = sender_params_str
        @sender_params_escape = sender_params_escape
      end

      def receive_data(client)
        args = read_args(client)
        if http_request?(args)
          client.puts HTTP_RESPONSE
        else
          json_data=JSON.parse(args)
          parsed_args=map_params_str(json_data)
          fix_icon_path! parsed_args
          system "#{@sender_app} #{parsed_args}"
        end
        client.close
      rescue => ex
        log ex.message
      end

      private

      # Maps params str with values
      #
      #@param data        [Map]     Array values map
      #
      #@return [String]
      def map_params_str(data)
        cmd=@sender_params_str + ''
        cmd.gsub! '%', '%%'

        replace=[]
        cmd.scan(/\[[^\]]+\]/).each do |part|
          variable=part[/\{[^\}]+\}/][1..-2]
          if data.key? variable
            replace << part[1..-2].sub('{' + variable + '}', escape_param(data[variable]))
            cmd.sub! part, '%'+replace.length.to_s+'$s'
          else
            cmd.sub! part, ''
          end
        end

        cmd.scan(/\{[^\}]+\}/).each do |part|
          variable=part[1..-2]
          if data.key? variable
            replace << escape_param(data[variable])
            cmd.sub! part, '%'+replace.length.to_s+'$s'
          end
        end
        cmd % replace
      end

      def log(message)
        File.open(@log_path, 'a+') do |log|
          log.puts "#{message}"
        end
      end

      # Escapes param
      #
      #@param param [String] Param
      #
      #@return [String]
      def escape_param(param)
        return param unless @sender_params_escape
        '"' + param.gsub('"', "\\\"").gsub("'", "\\'").gsub("\\", "\\\\") + '"'
      end

      # Gets log path
      #
      #@return [String]
      def log_path
        File.join Dir.tmpdir(), "vagrant-notify-error-#{@id}.log"
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
bind_ip = ARGV[2]
sender_app = ARGV[3]
sender_params_str = ARGV[4]
sender_params_escape = ARGV[5]

Vagrant::Notify::Server.run id, port, bind_ip, sender_app, sender_params_str, sender_params_escape