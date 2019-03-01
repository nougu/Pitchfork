module Pf
  module Stack
    class Md
      def initialize(args)
        @name    = args.fetch("Name")
        @chunk   = args["Chunk"]
        @level   = args.fetch("Level")
        @parity  = args["Parity"]
        @devices = args.fetch_paths("Devices")
        @spares  = args.fetch_paths("Spares", :nilable => true)

        args["Path"] = "/dev/#{@name}"
      end

      def exists?(opt={})
        path = "/dev/#{@name}"
        File.exists?(path) && File.stat(path).blockdev?
      end

      def create(opt={})
        cmd = []
        cmd << "echo y | mdadm --create"
        cmd << "/dev/#{@name}"
        cmd << "--chunk=#{@chunk}"   if @chunk
        cmd << "--level=#{@level}"
        cmd << "--parity=#{@parity}" if @parity
        cmd.push("--raid-devices=#{@devices.size}", *@devices)
        cmd.push("--spare-devices=#{@spares.size}", *@spares) if @spares
        cmd = cmd.join(" ")

        Pf.system(cmd)
      end

      def delete(opt={})
        Pf.system("mdadm --misc --stop /dev/#{@name}")
      end
    end
  end
end
