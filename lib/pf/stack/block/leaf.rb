module Pf
  module Stack
    class Leaf
      attr_reader :path

      def initialize(args)
        @path = args.fetch("Path")
      end

      def exists?(opt={})
        File.exists?(@path) && File.stat(@path).blockdev?
      end

      def create(opt={})
        # nothing to do
      end

      def delete(opt={})
        Pf.system("dd if=/dev/zero of=#{dev.path}") if opt[:zero]
      end
    end
  end
end
