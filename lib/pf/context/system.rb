require 'systemu'

module Pf
  def self.system(cmd, timeout: 180, check_status: true, &block)
    stat, out, err = systemu(cmd){|cid|
      sleep(timeout)
      Process.kill(9, cid) rescue true
    }
    fail <<-EOS.rm_spacepipe if check_status && !stat.success?
      |Error! failed to exec command
      | * Command : #{cmd}
      | * Status  : #{stat}
      | * Stdout  : #{(out.nil? or out.empty?) ? "(empty)" : "->\n#{out}<-" }
      | * Stderr  : #{(err.nil? or err.empty?) ? "(empty)" : "->\n#{err}<-" }
    EOS
    if block_given?
      return block.yield(stat, out, err)
    else
      return {:status => stat, :stdout => out, :stderr => err}
    end
  end
end
