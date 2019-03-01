require 'thor'

module Pf
  class CLI < Thor
    desc "build [OPTIONS] (-|PATH)", "Build device stack from the YAML file"

    option :"dry-run", :type => :boolean, :default => false, :desc => "Try to build device stack"

    def build(file)
      Pf.context(file, options) {
        if opts[:"dry-run"]
          puts "-> Execute (dry-run): Build a stack"
        else
          puts "-> Execute: Build a stack"
        end
        stack.map {|param|
          assemble(param)
        }.each {|dev, param|
          if dev.exists?
            puts "---> Skip device: #{param['Path']}"
          elsif opts[:"dry-run"]
            puts "---> Push device (dry-run): #{param['Path']}"
          else
            puts "---> Push device: #{param['Path']}"
            dev.create
          end
        }
        if opts[:"dry-run"]
          puts "-> Complete (dry-run): Stack would be built"
        else
          puts "-> Complete: Stack is built"
        end
        output
      }
    end 
  end
end
