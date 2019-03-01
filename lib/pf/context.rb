require 'yaml'

module Pf

  #
  # entry method
  #

  def self.context(file, opts, &block)
    $DEBUG = true if opts[:debug]
    Context.new(file, opts).instance_eval(&block)
  end

  class Context

    attr_reader :stack, :opts

    def initialize(file, opts)
      @opts = opts.dup.freeze
      @path_map = {}

      txt = read_file_or_stdin(file)
      data = YAML.load(txt)
      fail <<-EOS.rm_spacepipe if data.nil?
        |Error! empty YAML object
      EOS
      fail <<-EOS.rm_spacepipe unless data.instance_of? Array
        |Error! invalid YAML object
      EOS
      puts "-> YAML has been loaded successfully"
      @stack = data
    end

    def assemble(param)
      fail <<-EOS.rm_spacepipe unless param.is_a?(Hash)
        |Error! parameter is not a Hash
        | * parameter: #{param}
      EOS
      mname = param["Module"]  || "Leaf"
      cls = Pf::Stack.find_class(mname)
      param.extend(Pf::Param)
      dev = cls.send(:new, param)
      path = param["Path"]
      @path_map.merge!({ path => dev }){ fail "duplicate path: #{path}" }
      return [dev, param]
    end

    def templatize(param)
      fail <<-EOS.rm_spacepipe unless param.is_a?(String)
        |Error! parameter is not a String
        | * parameter: #{param}
      EOS
      mname = param
      cls = Pf::Stack.find_class(mname)
      psc = Pf::ParamScanner.new({ "Module" => cls.name.downcase })
      cls.send(:new, psc)
      return psc.to_h
    end

    OUTPUT =
      if STDOUT.isatty
        File.open('/dev/null', 'w')
      else
        $stdout = STDERR
        STDOUT
      end

    def output(mode: :yaml)
      case mode
      when :yaml then
        OUTPUT.puts(@stack.to_yaml)
      when :template then
        OUTPUT.puts(@stack.to_yaml
                          .sub(/^---\n/, '')
                          .gsub(/^- /, "- # set reference label if necessary\n  "))
      else
        fail <<-EOS.rm_spacepipe
          |Error! unsupported output mode specified.
          | * Mode: #{mode}
        EOS
      end
    end

    def traverse_hash(hash, &block)
      hash.each_value {|v|
        if v.is_a? Hash
          block.yield(v)
          traverse_hash(v, &block)
        end
      }
    end

    private

    def read_file_or_stdin(file)
      if file.nil? or file == "-"
        fail <<-EOS.rm_spacepipe if STDIN.isatty
          |Error! stdin must be an UNIX pipe stream
        EOS
        txt = STDIN.read
      else
        fail <<-EOS.rm_spacepipe unless File.exists?(file)
          |Error! file not found
          | * File : #{file}
        EOS
        stat = File::Stat.new(file)
        fail <<-EOS.rm_spacepipe unless stat.file?
          |Error! target path is not regular file
          | * Path : #{file}
        EOS
        fail <<-EOS.rm_spacepipe unless stat.readable?
          |Error! file is not readable
          | * File : #{file}
        EOS
        txt = File.read(file)
      end
      return txt
    end

  end
end

Dir.glob(File.expand_path('../context/*.rb', __FILE__))
   .each {|rb| require_relative rb }
