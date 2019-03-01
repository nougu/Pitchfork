require_relative 'dm_stack'

module Pf
  module Stack
    class DmThinThin
      include DmStack

      def initialize(args)
        @name = args.fetch("Name")
        @pool = args.fetch_path("Pool")
        @size = args.fetch("Size")
        @id   = args.fetch("Id")
        @ext  = args.fetch("External", "") # allows empty

        args["Path"] = "#{@@device_dir}#{@name}"
      end

      def exists?(opt={})
        DmStack.exists?(@name)
      end

      def create(opt={})
        DmStack.message(@pool, "create_thin #{@id}")
        DmStack.create(@name, "0 #{@size} thin #{@pool} #{@id} #{@ext}")
      end

      def delete(opt={})
        DmStack.remove(@name)
        DmStack.message(@pool, "delete #{@id}")
      end
    end
  end
end
