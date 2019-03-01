module Pf
  module Stack
    class Stgt

      # We use tgtadm --op show commmand for checking whether target existing.
      # Fix me because this command cannot display target information.

      def initialize(args)
        @name     = args.fetch("Name", "Ignored")
        @backend  = args.fetch_path("Backend")
        @protocol = args.fetch("Protocol", "iscsi")
        @tid      = args.fetch("Tid")
        @lun      = args.fetch("Lun")
        @bs_type  = args.fetch("BsType", "aio")
        @iqn      = args.fetch("Iqn")
        @ini_addr = args.fetch("InitiatorAddress", "ALL")
        @ini_name = args["InitiatorName"]

        # An iSCSI target doesn't have a significant backend path.
        # Message of exporting backend (placed lower on the stack) is settled instead.
        args["Path"] = "(#{@backend} as iSCSI target:tid=#{@tid} lun=#{@lun})"
      end

      def exists?(opt={})
        Pf.system("tgtadm --lld #{@protocol} --mode target --op show"){|_, out, _|
          target_exist = false
          out.each_line {|line|
            if target_exist
              return true  if /^\s{8}LUN:\s#{@lun}\n/ =~ line
              return false if /^Target/ =~ line
            else
              target_exist = true if /^Target\s#{@tid}:\s#{@iqn}\n/ =~ line
            end
          }
          return false
        }
      end

      def create(opt={})
        unless target_exist?
          Pf.system("tgtadm --lld #{@protocol} --mode target --op new --tid #{@tid} --targetname #{@iqn}")
          if @ini_name
            Pf.system("tgtadm --lld #{@protocol} --mode target --op bind --tid #{@tid} --initiator-name=#{@ini_name}")
          else
            Pf.system("tgtadm --lld #{@protocol} --mode target --op bind --tid #{@tid} --initiator-address=#{@ini_addr}")
          end
        end

        Pf.system("tgtadm --lld #{@protocol} --mode logicalunit --op new --tid #{@tid} --lun #{@lun} --backing-store #{@backend} --bstype #{@bs_type}")
      end

      def delete(opt={})
        Pf.system("tgtadm --lld #{@protocol} --mode logicalunit --op delete --tid #{@tid} --lun #{@lun}")
        Pf.system("tgtadm --lld #{@protocol} --mode target --op delete --tid #{@tid}") unless other_lun_exist?
      end

      private

      def target_exist?
        Pf.system("tgtadm --lld #{@protocol} --mode target --op show"){|_, out, _|
          out.each_line {|line|
            return true if /^Target\s#{@tid}:\s#{@iqn}\n/ =~ line
          }
          return false
        }
      end

      def other_lun_exist?
        Pf.system("tgtadm --lld #{@protocol} --mode target --op show"){|_, out, _|
          target_exist = false
          out.each_line {|line|
            if target_exist
              return true  if /^\s{8}LUN:\s[^0][0-9]*\n/ =~ line
              return false if /^Target/ =~ line
            else
              target_exist = true if /^Target\s#{@tid}:\s#{@iqn}\n/ =~ line
            end
          }
          return false
        }
      end

    end
  end
end
