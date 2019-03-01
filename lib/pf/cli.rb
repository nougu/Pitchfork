require 'thor'

module Pf
  class CLI < Thor; end
end

Dir.glob(File.expand_path('../cli/*.rb', __FILE__))
   .each {|rb| require_relative rb }
