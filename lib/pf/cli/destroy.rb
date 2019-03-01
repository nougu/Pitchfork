require 'thor'

module Pf
  class CLI < Thor
    desc "destroy [OPTIONS] (-|PATH)", "Destroy device stack from the YAML file"

    option :zero, :type => :boolean, :aliases => "-z", :desc => "Try zero-clear device(s) after destroying stack"
    option :"dry-run", :type => :boolean, :default => false, :desc => "Try to build device stack"

    def destroy(file)
      Pf.context(file, options) {
        if opts[:"dry-run"]
          puts "-> Execute (dry-run): Destroy a stack"
        else
          puts "-> Execute: Destroy a stack"
        end
        stack.map {|param|
          assemble(param)
        }.reverse.each {|dev, param|
          if param["Sealed"]
            puts "---> Skip device (sealed): #{param['Path']}"
          elsif not dev.exists?
            puts "---> Skip device: #{param['Path']}"
          elsif opts[:"dry-run"]
            puts "---> Pop device (dry-run): #{param['Path']}"
          else
            puts "---> Pop device: #{param['Path']}"
            dev.delete(:zero => opts[:zero])
          end
        }
        if opts[:"dry-run"]
          puts "-> Complete (dry-run): Stack would be destroyed"
        else
          puts "-> Complete: Stack is destroyed"
        end
        output
      }
    end
  end
end
