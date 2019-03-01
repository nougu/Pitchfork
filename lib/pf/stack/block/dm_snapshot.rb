require_relative 'dm_stack'

module Pf
  module Stack
    class DmSnapshot
      include DmStack

      def initialize(args)
        @name        = args.fetch("Name")
        @master      = args.fetch_path("Master")
        @cow         = args.fetch_path("Cow")
        @size        = args.fetch_size("Size", @master)
        @persistency = args.fetch("Persistency", "P")
        @chunk_size  = args.fetch("ChunkSize", 8)

        args["Path"] = "#{@@device_dir}#{@name}"
      end

      def exists?(opt={})
        DmStack.exists?(@name)
      end

      def create(opt={})
        DmStack.create(@name, "0 #{@size} snapshot #{@master} #{@cow} #{@persistency} #{@chunk_size}")
      end

      def delete(opt={})
        DmStack.remove(@name)
      end
    end
  end
end
