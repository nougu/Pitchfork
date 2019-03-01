require 'sinatra/base'
require 'sinatra/reloader'
require 'fileutils'

module Pf
  class Daemon < Sinatra::Base
    set :bind, '0.0.0.0'
    set :port, 7066

    configure :development do
      register Sinatra::Reloader
    end

    def self.dir(key)
      dp = "/var/tmp/pf/#{key}"
      FileUtils.mkdir_p(dp) unless Dir.exists?(dp)
      dp
    end

    @@saved_dir = dir("saved")
    @@built_dir = dir("built")
    @@raw_dir = dir("raw")

  end
end

Dir.glob(File.expand_path('../daemon/*.rb', __FILE__))
   .each {|rb| require_relative rb }
