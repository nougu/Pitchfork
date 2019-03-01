module Pf
  module Stack
    class IscsiInitiator

      # Device path /dev/disk/by-path/ is not unique according to Redhat(Refer to the follow URL).
      # https://access.redhat.com/documentation/ja-JP/Red_Hat_Enterprise_Linux/6/html/Storage_Administration_Guide/persistent_naming.html
      # We use this path for the time being.

      # We support only creating one lun per target.

      @@device_dir = "/dev/disk/by-path/"

      def initialize(args)
        @name     = args.fetch("Name", "Ignored")
        @lun      = args.fetch("Lun")
        @protocol = args.fetch("Protocol", "iscsi")
        @target   = args.fetch("Target")
        @iqn      = args.fetch("Iqn")
        @port     = args.fetch("Port", 3260 )

        if @target == "localhost"
          @target_addr = "::1"
        else
          @target_addr = @target
        end
        args["Path"] = "#{@@device_dir}ip-#{@target_addr}:#{@port}-#{@protocol}-#{@iqn}-lun-#{@lun}"
        @path = args["Path"]
      end

      def exists?(opt={})
        File.exists?(@path)
      end

      def create(opt={})
        Pf.system("iscsiadm -m discovery --type sendtargets -p #{@target}")
        Pf.system("iscsiadm -m node -p #{@target} -T #{@iqn} --op update -n node.transport_name -v iser") if @protocol == "iser"
        if session_exist?
          operation = "rescan"
        else
          operation = "login"
        end
        Pf.system("iscsiadm -m node -T #{@iqn} -p #{@target} --#{operation}")
      end

      def delete(opt={})
        unless other_lun_exist?
          Pf.system("iscsiadm -m node -T #{@iqn} -p #{@target} --logout")
          Pf.system("iscsiadm -m node -o delete #{@iqn} -p #{@target}")      
        end
      end

      private

      def session_exist?
        # Return value is not 0 when session not found.
        # Therefore, check_status is false.
        Pf.system("iscsiadm -m session | grep #{@iqn}", :check_status => false) {|_, out, _|
          return !(out.empty?)
        }
      end

      def other_lun_exist?
        # Return value is not 0 when grep output is empty.
        # Therefore, check_status is false.
        Pf.system("ls #{@@device_dir}ip-#{@target_addr}:#{@port}-#{@protocol}-#{@iqn}-* | grep -v #{@path}", :check_status => false) {|_, out, _|
          return !(out.empty?)
        }
      end

    end
  end
end
