module Vagrant
  module Notify
    class Config < Vagrant.plugin(2, :config)

      # Enable?
      attr_accessor :enable

      # Bind IP
      attr_accessor :bind_ip

      # Notify send application
      attr_accessor :sender_app

      # Notify send params string
      attr_accessor :sender_params_str

      # Sender params escape
      attr_accessor :sender_params_escape

      def initialize()
        @enable  = UNSET_VALUE
        @sender_app = UNSET_VALUE
        @sender_params_str = UNSET_VALUE
        @sender_params_escape = UNSET_VALUE
      end

      def validate(machine)
        errors = _detected_errors

        if backed_by_cloud_provider?(machine)
          machine.ui.warn("Disabling vagrant-notify, cloud provider #{machine.provider_name} in use.")

          @enable = false
        end

        if @enable != 0
          if @enable != false && @enable != true
            errors << "Unknown option for enable: #{@enable}"
          end
        end

        if @sender_params_escape != false && @sender_params_escape != true && @sender_params_escape != UNSET_VALUE
          errors << "Unknown option for @sender_params_escape: #{@sender_params_escape}"
        end

        if backed_by_supported_provider?(machine)
          if @bind_ip.is_a?(String)
            require "resolv"
            unless @bind_ip =~ Resolv::IPv4::Regex
              errors << "Invalid bind IP address: #{@bind_ip}"
            end
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
        @sender_app = "notify-send" if @sender_app == UNSET_VALUE
        @sender_params_str = "[--app-name {app_name}] [--urgency {urgency}] [--expire-time {expire_time}] [--icon {icon}] [--category {category}] [--hint {hint}] {title} [{message}]" if @sender_params_str == UNSET_VALUE
        @sender_params_escape = true if @sender_app == UNSET_VALUE
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
