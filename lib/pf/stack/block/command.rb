module Pf
  module Stack
    class Command
      def initialize(args)
        @path   = args.fetch("Path")
        @exec   = args.fetch("Exec")
        @unexec = args.fetch("Unexec"){
          warn(<<-EOS.rm_spacepipe)
            |We STRONGLY RECOMMEND to define 'Unexec' parameter to be able to dispose side effects
          EOS
        }
      end

      def exists?(opt={})
        File.exists?(@path)
      end

      def create(opt={})
        Pf.system(@exec)
      end

      def delete(opt={})
        Pf.system(@unexec) unless @unexec.nil?
      end
    end
  end
end
