module Vagrant
  module Notify
    module Action
      class InstallCommand
        def initialize(app, env)
          @app = app
        end

        def call(env)
          path = compile_command(env)
          install_command_on_guest(env, path)

          @app.call env
        end

        private

        def compile_command(env)
          host_port        = env[:notify_data][:port]
          template_binding = OpenStruct.new(:host_ip => local_ip, :host_port => host_port, :shared_folder => '/tmp/vagrant-notify')
          command_template = ERB.new(Vagrant::Notify.files_path.join('notify-send.erb').read)
          command          = command_template.result(template_binding.instance_eval { binding })

          env[:tmp_path].join('vagrant-notify-send').open('w') { |f| f.write(command) }
        end

        def install_command_on_guest(env, command_path)
          source = env[:tmp_path].join 'vagrant-notify-send'
          env[:machine].communicate.upload(source.to_s, '/tmp/notify-send')
          env[:machine].communicate.sudo('mv /tmp/notify-send /usr/bin/notify-send && chmod +x /usr/bin/notify-send')
        end

        ##
        # Returns the local IP address of the host running the vagrant VMs.
        #
        # Thanks to:
        #   https://github.com/fnichol/vagrant-butter/blob/master/lib/vagrant/butter/helpers.rb
        #   https://github.com/jedi4ever/veewee/blob/c75a5b175c5b8ac7e5aa3341e93493923d0c7af0/lib/veewee/session.rb#L622
        #
        # @return [String] the local IP address
        def local_ip
          @local_ip ||= begin
            # turn off reverse DNS resolution temporarily
            orig, Socket.do_not_reverse_lookup =
              Socket.do_not_reverse_lookup, true

            UDPSocket.open do |s|
              s.connect '64.233.187.99', 1
              s.addr.last
            end
          ensure
            Socket.do_not_reverse_lookup = orig
          end
        end
      end
    end
  end
end
