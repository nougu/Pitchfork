require 'sinatra/base'
require 'fileutils'

module Pf
  class Daemon < Sinatra::Base
    get "/build/:name" do |name|
      return status 400 if name == ''
      begin
        saved = "#{@@saved_dir}/#{name}.yml"
        built = "#{@@built_dir}/#{name}.yml"
        fail unless File.exists?(saved)
        raw = File.readlink(saved)
        Pf::CLI.new.build(saved)
        FileUtils.symlink(raw, built) unless File.exists?(built)
      rescue => e
        puts e.message
        puts e.backtrace
        return status 500
      end
      'OK'
    end
  end
end
