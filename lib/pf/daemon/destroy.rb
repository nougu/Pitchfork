require 'sinatra/base'

module Pf
  class Daemon < Sinatra::Base
    get "/destroy/:name" do |name|
      begin
        saved = "#{@@saved_dir}/#{name}.yml"
        built = "#{@@built_dir}/#{name}.yml"
        fail unless File.exists?(saved)
        Pf::CLI.new.destroy(saved)
        File.delete(built) if File.exists?(built)
      rescue => e
        puts e.message
        puts e.backtrace
        return status 500
      end
      'OK'
    end
  end
end
