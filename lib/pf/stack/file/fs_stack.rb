module Pf
  module Stack
    module FsStack
      class << self
        def mounted?(backend, mount, type)
          chk = Pf.system("mount -l | grep -E \"^#{backend} on #{mount} type #{type}\"", :check_status => false)
          chk[:status].success?
        end

        def mkfs(backend, type)
          Pf.system("mkfs -t #{type} #{backend}")
        end

        def mount(backend, mount)
          Pf.system("mkdir -p #{mount}")
          Pf.system("mount #{backend} #{mount}")
        end

        def umount(mount)
          Pf.system("umount #{mount}")
          Pf.system("rmdir #{mount}")
        end
      end
    end
  end
end
