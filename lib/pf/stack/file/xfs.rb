require_relative 'fs_stack'

module Pf
  module Stack
    class Xfs
      include FsStack

      XFS_MAGIC = "XFSB"

      def initialize(args)
        @mount   = args.fetch("Mount")
        @backend = args.fetch_path("Backend")

        args["Path"] = @mount
      end

      def exists?(opt={})
        FsStack.mounted?(@backend, @mount, "xfs")
      end

      def create(opt={})
        FsStack.mkfs(@backend, "xfs") unless created?
        FsStack.mount(@backend, @mount)
      end

      def delete(opt={})
        FsStack.umount(@mount)
      end

      private

      def created?
        IO.read(@backend, XFS_MAGIC.size) == XFS_MAGIC
      end
    end
  end
end
