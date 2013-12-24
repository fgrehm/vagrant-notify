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
          template_binding = OpenStruct.new(:host_port => host_port, :shared_folder => '/tmp/vagrant-notify')
          command_template = ERB.new(Vagrant::Notify.files_path.join('notify-send.erb').read)
          command          = command_template.result(template_binding.instance_eval { binding })

          env[:tmp_path].join('vagrant-notify-send').open('w') { |f| f.write(command) }
        end

        def install_command_on_guest(env, command_path)
          source = env[:tmp_path].join 'vagrant-notify-send'
          env[:machine].communicate.upload(source.to_s, '/tmp/notify-send')
          env[:machine].communicate.sudo('mv /usr/bin/{notify-send,notify-send.bkp}; exit 0')
          env[:machine].communicate.sudo('mv /tmp/notify-send /usr/bin/notify-send && chmod +x /usr/bin/notify-send')
        end
      end
    end
  end
end
