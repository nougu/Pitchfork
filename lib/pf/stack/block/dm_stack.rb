module Pf
  module Stack

    DM_TARGETS = Pf.system("dmsetup targets"){|_, out, _|
      Hash[out.lines.map{|ln| ln.split(" ")}]
    }

    module DmStack
      class << self
        @@device_dir = "/dev/mapper/"

        def create(name, table)
          Pf.system "echo \"#{table}\" | dmsetup create #{name}"
        end

        def remove(name)
          Pf.system "dmsetup remove #{name}"
        end

        def message(name, msg, pos: 0)
          Pf.system "dmsetup message #{name} #{pos} \"#{msg}\""
        end

        def suspend(name) 
          Pf.system "dmsetup suspend #{name}"
        end

        def resume(name)
          Pf.system "dmsetup resume #{name}"
        end

        def exists?(name)
          path = "#{@@device_dir}/#{name}"
          File.exists?(path) && File.stat(path).blockdev?
        end
      end
    end
  end
end
