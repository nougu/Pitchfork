require 'set'
require 'thor'

module Pf
  class CLI < Thor
    desc "seal [OPTIONS] (-|PATH) DEV[,...]", "Seal device(s) in the YAML file"

    def seal(file, seal, *seals)
      # Merge the arguments seal & seals into one Set
      seal_set = Set.new(seals.unshift(seal))

      Pf.context(file, options) {
        puts "-> Execute: Seal devices"
        stack.map {|param|
          assemble(param)
        }.each {|_, param|
          if seal_set.include? param["Path"]
            traverse_hash(param) {|h|
              seal_set << h["Path"]
            }
          end
        }.each {|_, param|
          path = param["Path"]
          if seal_set.include? path
            puts "---> Seal device: #{path}"
            param["Sealed"] = true
          else
            puts "---> Skip device: #{path}"
          end
        }
        puts "-> Complete: Devices are sealed: #{seal_set.to_a.join(',')}"
        output
      }
    end
  end
end
