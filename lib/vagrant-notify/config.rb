module Vagrant
  module Notify
    class Config < Vagrant.plugin(2, :config)
      attr_accessor :enable

      def initialize()
        @enable = UNSET_VALUE
      end

      def validate(machine)
        errors = _detected_errors

        if backed_by_cloud_provider?(machine)
          machine.ui.warn("Disabling vagrant-notify, cloud provider #{machine.provider_name} in use.")

          @enable = false
        end

        if @enable != 0
          if @enable != false && @enable != true
            errors << "Unknown option: #{@enable}"

            { "notify" => errors }
          end
        end
      end

      def finalize!
        @enable = 0 if @enable == UNSET_VALUE
      end

      private

      def backed_by_cloud_provider?(machine)
        CLOUD_PROVIDERS.include?(machine.provider_name.to_s)
      end
    end
  end
end
