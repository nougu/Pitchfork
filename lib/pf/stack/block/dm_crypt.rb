require_relative 'dm_stack'

module Pf
  module Stack
    class DmCrypt
      include DmStack

      def initialize(args)
        @name            = args.fetch("Name")
        @backend         = args.fetch_path("Backend")
        @size            = args.fetch_size("Size", @backend)
        @cipher          = args.fetch("Cipher")
        @key             = args.fetch("Key")
        @iv_offset       = args.fetch("IvOffset", 0)
        @data_offset     = args.fetch("DataOffset", 0)
        @discards        = args["Discards"]
        @same_cpu_crypt  = args["SameCpuCrypt"]
        @same_cpu_submit = args["SameCpuSubmit"]

        args["Path"] = "#{@@device_dir}#{@name}"
      end

      def exists?(opt={})
        DmStack.exists?(@name)
      end

      def create(opt={})
        opt_args = []
        opt_args << "allow_discards"         if @discards
        opt_args << "same_cpu_crypt"         if @same_cpu_crypt
        opt_args << "submit_from_crypt_cpus" if @same_cpu_submit
        opt_args.unshift(opt_args.size)      unless opt_args.empty?
        opt_args = opt_args.join(" ")

        DmStack.create(@name, "0 #{@size} crypt #{@cipher} #{@key} #{@iv_offset} #{@backend} #{@data_offset} #{opt_args}")
      end

      def delete(opt={})
        DmStack.remove(@name)
      end
    end
  end
end
