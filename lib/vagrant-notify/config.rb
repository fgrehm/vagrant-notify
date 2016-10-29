module Vagrant
  module Notify
    class Config < Vagrant.plugin(2, :config)
      attr_accessor :enable, :bind_ip

      def initialize()
        @enable  = UNSET_VALUE
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
          end
        end

        if backed_by_supported_provider?(machine)
          if @bind_ip.is_a?(String)
            require "resolv"
            unless @bind_ip =~ Resolv::IPv4::Regex
              errors << "Invalid bind IP address: #{@bind_ip}"
            end
          elsif @bind_ip.is_a?(FalseClass) || @bind_ip.is_a?(Fixnum) || @bind_ip.is_a?(Array) || @bind_ip.is_a?(Hash)
            errors << "Unknown bind IP address: #{@bind_ip}"
          else
            @bind_ip = SUPPORTED_PROVIDERS[machine.provider_name]
          end
        else
          machine.ui.warn("#{machine.provider_name.to_s} provider is not supported by vagrant-notify. Please feel free to open a new issue https://github.com/fgrehm/vagrant-notify/issues")

          @enable = false
        end

        { "notify" => errors }
      end

      def finalize!
        @enable = 0 if @enable == UNSET_VALUE
      end

      private

      def backed_by_cloud_provider?(machine)
        CLOUD_PROVIDERS.include?(machine.provider_name.to_s)
      end
      def backed_by_supported_provider?(machine)
        SUPPORTED_PROVIDERS.has_key?(machine.provider_name)
      end
    end
  end
end
