require_relative 'dm_stack'

module Pf
  module Stack
    class DmThinSnap
      include DmStack

      def initialize(args)
        @name   = args.fetch("Name")
        @pool   = args.fetch_path("Pool")
        @size   = args.fetch("Size")
        @id     = args.fetch("Id")
        origin  = args.fetch("Origin")
        @opath  = origin.fetch("Path")
        @oid    = origin.fetch("Id")

        args["Path"] = "#{@@device_dir}#{@name}"
      end

      def exists?(opt={})
        DmStack.exists?(@name)
      end

      def create(opt={})
        DmStack.suspend(@opath)
        DmStack.message(@pool, "create_snap #{@id} #{@oid}")
        DmStack.resume(@opath)
        DmStack.create(@name, "0 #{@size} thin #{@pool} #{@id}")
      end

      def delete(opt={})
        DmStack.remove(@name)
      end
    end
  end
end
