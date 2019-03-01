require_relative 'fs_stack'

module Pf
  module Stack
    class Ext4
      include FsStack

      def initialize(args)
        @mount   = args.fetch("Mount")
        @backend = args.fetch_path("Backend")

        args["Path"] = @mount
      end

      def exists?(opt={})
        FsStack.mounted?(@backend, @mount, "ext4")
      end

      def create(opt={})
        FsStack.mkfs(@backend, "ext4") unless created?
        FsStack.mount(@backend, @mount)
      end

      def delete(opt={})
        FsStack.umount(@mount)
      end

      private

      def created?
        chk = Pf.system("dumpe2fs -h #{@backend}", :check_status => false)
        chk[:status].success?
      end
    end
  end
end
