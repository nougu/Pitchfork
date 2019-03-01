require_relative 'fs_stack'

module Pf
  module Stack
    class NfsClient
      include FsStack

      def initialize(args)
        @mount   = args.fetch("Mount")
        @export  = args.fetch("Export")
        @host    = args.fetch("Host", "localhost")
        @backend = "#{@host}:#{@export}"

        args["Path"] = "(#{@mount} as nfs #{@backend})"
      end

      def exists?(opt={})
        chk = Pf.system("nfsstat -m | \grep -E \"^#{@mount}\"", :check_status => false)
        chk[:status].success?
      end

      def create(opt={})
        FsStack.mount(@backend, @mount, "nfs4")
      end

      def delete(opt={})
        FsStack.umount(@mount)
      end
    end
  end
end
