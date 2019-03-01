require 'sinatra/base'
require 'digest/md5'

module Pf
  class Daemon < Sinatra::Base

    get "/" do
      "-> hello\n"
    end

    put "/:name" do |name|
      body = request.body.read
      return status 400 if body == ''

      saved = "#{@@saved_dir}/#{name}.yml"
      begin
        md5 = Digest::MD5.hexdigest(body)
        raw = "#{@@raw_dir}/#{md5}.yml"
        File.write(raw, body) unless File.exists?(raw)
        File.symlink(raw, saved) unless File.exists?(saved)
        Pf.context(saved, {}) {
           stack.map {|param| assemble(param) }
        }
      rescue => e
        puts e.backtrace
        File.delete(saved) if File.exists?(saved)
        return status 500
      end
      'OK'
    end

    delete "/:name" do |name|
      saved = "#{@@saved_dir}/#{name}.yml"
      begin
        raw = File.readlink(saved)
        File.delete(saved)
        File.delete(raw)
      rescue => e
        puts e.backtrace
        File.delete(yml) if not yml.nil? and File.exists?(yml)
        return status 500
      end
      'OK'
    end
  end
end
