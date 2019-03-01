module Pf
  module Stack
    class Loopback
      def initialize(args)
        @name    = args.fetch("Name")
        @backend = args.fetch_path("Backend")

        args["Path"] = "/dev/#{@name}"
      end

      def exists?(opt={})
        chk = Pf.system("losetup | grep /dev/#{@name}", :check_status => false)
        chk[:status].success?
      end

      def create(opt={})
        Pf.system("losetup /dev/#{@name} #{@backend}")
      end

      def delete(opt={})
        Pf.system("losetup -d /dev/#{@name}")
      end
    end
  end
end
