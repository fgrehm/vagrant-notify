module Vagrant
  module Notify
    module Action
      class SetSharedFolder
        def initialize(app, env)
          @app = app
        end

        def call(env)
          host_dir = Pathname("/tmp/vagrant-notify/#{env[:machine].id}")
          FileUtils.mkdir_p host_dir.to_s unless host_dir.exist?
          env[:machine].config.vm.synced_folder host_dir, "/tmp/vagrant-notify", id: "vagrant-notify"
          @app.call(env)
        end
      end
    end
  end
end
