require_relative 'dm_stack'

module Pf
  module Stack
    class DmThinPool
      include DmStack

      def initialize(args)
        @name = args.fetch("Name")
        @meta = args.fetch_path("Meta")
        @data = args.fetch_path("Data")
        @blks = args.fetch("BlockSize")
        @lowm = args.fetch("LowWaterMark")
        @size = args.fetch_size("Size", @data)

        args["Path"] = "#{@@device_dir}#{@name}"
      end

      def exists?(opt={})
        DmStack.exists?(@name)
      end

      def create(opt={})
        DmStack.create(@name, "0 #{@size} thin-pool #{@meta} #{@data} #{@blks} #{@lowm}")
      end

      def delete(opt={})
        DmStack.remove(@name)
      end
    end
  end
end
