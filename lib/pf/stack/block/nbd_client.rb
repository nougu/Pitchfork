module Pf
  module Stack
    class NbdClient
      def initialize(args)
        @name   = args.fetch("Name")
        @export = args.fetch("Export")
        @host   = args.fetch("Host", "localhost")

        args["Path"] = "/dev/#{@name}"
      end

      def exists?(opt={})
        chk = Pf.system("nbd-client -c /dev/#{@name}", :check_status => false)
        chk[:status].success?
      end

      def create(opt={})
        Pf.system("nbd-client #{@host} -N #{@export} /dev/#{@name}")
      end

      def delete(opt={})
        Pf.system("nbd-client -d /dev/#{@name}")
      end
    end
  end
end
