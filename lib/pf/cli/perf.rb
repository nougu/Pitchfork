require 'thor'
require 'yaml'
require 'erb'

module Pf
  class CLI < Thor
    desc "perf [OPTIONS] (-|PATH)", "Run a performance benchmark based on the YAML file"

    def perf(file)
      raise 'A required program of FIO is NOT exist in this system...' unless system 'hash fio 2>/dev/null'
      #rpm -ivh http://ftp.riken.jp/Linux/fedora/epel/7Server/x86_64/f/fio-2.2.8-2.el7.x86_64.rpm

      puts "-> Execute: a performance benchmark."
      conf = YAML.load_file(file)
      dir = '/var/tmp/pf/perf'
      if not Dir.exist?(dir)
        Dir.mkdir(dir)
      end
      jobfile = open('/var/tmp/pf/perf/job.fio', 'w')
      erb = ERB.new(job_template)
      jobfile.write(erb.result(binding))
      jobfile.close()

      print Pf.system("fio #{jobfile.path}")[:stdout]
      puts "-> Complete: a performance benchmark."
    end 

    private

    def job_template
      <<-JOBFILE
[pf_job]
group_reporting
time_based
exitall
ioengine=libaio
invalidate=1
direct=1
filename=<%= conf['target-path'] %>
runtime=<%= conf['duration'] %>
rw=<%= conf['rw'] %>
numjobs=<%= conf['numjobs'] %>
bs=<%= conf['blocksize'] %>
      JOBFILE
    end
  end
end
