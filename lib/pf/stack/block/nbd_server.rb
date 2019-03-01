module Pf
  module Stack
    class NbdServer

      # config file of nbd-server (singleton in one node)
      CONFIG_FILE = "/etc/nbd-server/config"

      # Generate config file if not exist
      unless File.exists?(CONFIG_FILE)
        FileUtils.mkdir_p(File.dirname(CONFIG_FILE))
        File.write(CONFIG_FILE, <<-EOS.rm_spacepipe)
          |[generic]
          |    # section is required (even if it's empty)
        EOS
      end

      def initialize(args)
        @name   = args.fetch("Name")
        @device = args.fetch_path("Device")

        # A NBD server doesn't have a significant device path.
        # Message of exporting device (placed lower on the stack) is settled instead.
        args["Path"] = "(#{@device} as nbd:#{@name})"
      end

      def exists?(opt={})
        chk = Pf.system("pgrep nbd-server", :check_status => false)
        chk[:status].success? and File.read(CONFIG_FILE).include?("[#{@name}]")
      end

      def create(opt={})
        config = File.read(CONFIG_FILE)
        config += "\n" + <<-EOS.rm_spacepipe
          |[#{@name}]
          |    exportname = #{@device}
        EOS
        File.write(CONFIG_FILE, config)

        Pf.system("pkill -9 nbd-server", :check_status => false)
        Pf.system("nbd-server -C #{CONFIG_FILE}")
      end

      def delete(opt={})
        config = File.read(CONFIG_FILE)
        config = config.gsub(/\n\[#{@name}\][^\[]*/,'')
        File.write(CONFIG_FILE, config)

        Pf.system("pkill -9 nbd-server", :check_status => false)
      end
    end
  end
end
