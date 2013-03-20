module Vagrant
  module Notify
    class Data
      def initialize(data_dir)
        @data_dir = data_dir
      end

      def []=(key, value)
        @data_dir.join(key.to_s).open("w+") { |f| f.write(value) }
      end

      def [](key)
        file = @data_dir.join(key.to_s)
        file.read if file.file?
      end
    end
  end
end
