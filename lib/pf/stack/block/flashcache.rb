require_relative 'dm_stack'

module Pf
  module Stack
    class Flashcache
      include DmStack

      # Depend on flashcache superblock layout
      STATE_ADDRESS    = 16
      STATE_BYTE       = 4
      state_dirty      = 0xdeadbeef
      state_clean      = 0xfacecafe
      state_fastclean  = 0xcafefeed
      state_unstable   = 0xc8249756
      STATE_MAGICS     = [state_dirty, state_clean, state_fastclean, state_unstable]

      def initialize(args)
        @name       = args.fetch("Name")
        @policy     = args.fetch("Policy", "back")
        @wb_only    = args["WriteBackOnly"]
        @bs         = args["BlockSize"]
        @md_bs      = args["MdBlockSize"]
        @cache_size = args["CacheSize"]
        @assoc      = args["Assoc"]
        @cache      = args.fetch_path("Cache")
        @backend    = args.fetch_path("Backend")

        args["Path"] = "#{@@device_dir}#{@name}"
      end

      def exists?(opt={})
        DmStack.exists?(@name)
      end

      def create(opt={})
        cmd = generate_command
        Pf.system(cmd)
      end

      def delete(opt={})
        DmStack.remove(@name)
      end

      private

      def is_superblock_marked?
        state = IO.read(@cache, STATE_BYTE, STATE_ADDRESS).unpack("I*").first
        STATE_MAGICS.include?(state)
      end

      def generate_command
        cmd = []
        if is_superblock_marked?
          cmd << "flashcache_load"
          cmd << @cache
          cmd << @name if @name
        else
          cmd << "flashcache_create"
          cmd << "-p" << @policy
          cmd << "-w"                if @wb_only
          cmd << "-b" << @bs         if @bs
          cmd << "-m" << @md_bs      if @md_bs
          cmd << "-s" << @cache_size if @cache_size
          cmd << "-a" << @assoc      if @assoc
          cmd << @name
          cmd << @cache
          cmd << @backend
        end
        cmd.join(" ")
      end
    end
  end
end
