require 'thor'

module Pf
  class CLI < Thor
    desc "init [OPTIONS] (-|PATH)", "Generate YAML template from a list of block device modules"

    def init(file)
      Pf.context(file, options) {
        puts "-> Execute: Generate yml template"
        stack.map!{|param|
          puts "---> Expand module: #{param}"
          templatize(param)
        }
        puts "-> Complete: Template is generated"
        output(:mode => :template)
      }
    end 
  end
end
