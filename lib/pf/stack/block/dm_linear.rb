require_relative 'dm_stack'

module Pf
  module Stack
    class DmLinear
      include DmStack

      def initialize(args)
        @name    = args.fetch("Name")
        @devices = args.fetch("Devices")

        args["Path"] = "#{@@device_dir}#{@name}"
      end

      def exists?(opt={})
        DmStack.exists?(@name)
      end

      def create(opt={})
        cmd = @devices.map{|dev|
          "#{dev["LogicalStart"]} #{dev["LogicalEnd"]} linear #{dev["Device"]["Path"]} #{dev["PhysicalStart"]}"
        }.join("\n")
        DmStack.create(@name, cmd)
      end

      def delete(opt={})
        DmStack.remove(@name)
      end
    end
  end
end
