module Vagrant
  module Notify
    module Action
      class PrepareDataDir
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant::notify::action::prepare_data_dir")
        end

        def call(env)
          path = env[:machine].data_dir.join('vagrant-notify')
          unless path.directory?
            @logger.debug 'Creating data directory'
            path.mkdir
          end
          @app.call env
        end
      end
    end
  end
end
