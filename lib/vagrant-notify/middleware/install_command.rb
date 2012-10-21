module Vagrant
  module Notify
    module Middleware
      class InstallCommand
        def initialize(app, env)
          @app = app
          @command_template_file = Vagrant::Notify.files_path + '/notify-send.erb'
        end

        def call(env)
          # TODO: Output logging info
          path = compile_command(env)
          install_command_on_guest(env, path)
          @app.call(env)
        end

        def host_ip(env)
          ip = nil
          env[:vm].channel.execute('echo -n $SSH_CLIENT | cut -d" " -f1') do |buffer, data|
            ip = data.chomp if buffer == :stdout
          end
          ip
        end

        private

        def host_port
          # TODO: Add configuration for which port to use
          8081
        end

        def compile_command(env)
          template_binding = OpenStruct.new(:host_ip => host_ip(env), :host_port => host_port)
          command = ERB.new(File.read(@command_template_file)).result(template_binding.instance_eval { binding })
          File.open(env[:vm].env.tmp_path + 'vagrant-notify-send', 'w') { |f| f.write(command) }
        end

        def install_command_on_guest(env, command_path)
          source = env[:vm].env.tmp_path + 'vagrant-notify-send'
          env[:vm].channel.upload(source.to_s, '/tmp/notify-send')
          env[:vm].channel.sudo('mv /tmp/notify-send /usr/bin/notify-send && chmod +x /usr/bin/notify-send')
        end
      end
    end
  end
end
