module Pf
  module Stack
    class NfsServer
      def initialize(args)
        @export = args.fetch("Export")
        @host   = args.fetch("Host", "localhost")
        @option = args.fetch("Option", "ro")

        args["Path"] = "(#{@export} as nfs)"
      end

      def exists?(opt={})
        chk = Pf.system("systemctl start nfs-server", :check_status => false)
        chk = Pf.system("exportfs -s | \grep -E \"^#{@export}\"", :check_status => false)
        chk[:status].success?
      end

      def create(opt={})
        Pf.system("exportfs -iv -o #{@option} #{@host}:#{@export}")
      end

      def delete(opt={})
        Pf.system("exportfs -uv #{@host}:#{@export}")
      end
    end
  end
end
