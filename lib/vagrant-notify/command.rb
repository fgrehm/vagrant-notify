
require_relative 'action'

module Vagrant
  module Notify
    class Command < Vagrant.plugin('2', :command)

      def self.synopsis
        "plugin: vagrant-notify: forwards notify-send from guest to host machine and notifies provisioning status"
      end

      def execute
        options = {}
        opts = OptionParser.new do |o|
          o.banner = 'Usage: vagrant notify'
          o.separator ''
          o.version = Vagrant::Notify::VERSION
          o.program_name = 'vagrant notify'

          o.on('-h', '--help', 'Display this screen.' )                           { options[:help] = true }
          o.on('--status', 'Show vagrant-notify-server daemon status. (default)') { options[:status] = true }
          o.on('--start', 'Manually start vagrant-notify-server daemon.')         { options[:start] = true }
          o.on('--stop', 'Manually stop vagrant-notify-server daemon.')           { options[:stop] = true }
          o.on('--restart', 'Manually restart vagrant-notify-server daemon.')     { options[:restart] = true }
        end

        argv = parse_options(opts)
       
        with_target_vms(argv, options) do |machine|
          if options[:help]
            @env.ui.info(opts)
            return 0
          end
          if options[:status] || options.length == 0
            @env.action_runner.run(Vagrant::Notify::Action.action_status_server, {
              :machine => machine,
            })
            return 0
          end
          if options[:stop]
            @env.action_runner.run(Vagrant::Notify::Action.action_stop_server, {
              :machine => machine,
            })
            return 0
          end
          if options[:start]
            @env.action_runner.run(Vagrant::Notify::Action.action_start_server, {
              :machine => machine,
            })
            return 0
          end
          if options[:restart]
            @env.action_runner.run(Vagrant::Notify::Action.action_stop_server, {
              :machine => machine,
            })
            @env.action_runner.run(Vagrant::Notify::Action.action_start_server, {
              :machine => machine,
            })
            return 0
          end
        end
      end

    end
  end
end
