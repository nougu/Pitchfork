require_relative 'dm_stack'

module Pf
  module Stack
    class DmZero
      include DmStack

      def initialize(args)
        @name = args.fetch("Name")
        @size = args.fetch("Size")

        args["Path"] = "#{@@device_dir}#{@name}"
      end

      def exists?(opt={})
        DmStack.exists?(@name)
      end

      def create(opt={})
        DmStack.create(@name, "0 #{@size} zero")
      end

      def delete(opt={})
        DmStack.remove(@name)
      end
    end
  end
end
