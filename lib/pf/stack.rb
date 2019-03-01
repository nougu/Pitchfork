module Pf
  module Stack

    def self.find_class(name)
      first = true
      cname = name.split(/[\-_]/).map(&:capitalize).join
      begin
        cls = Pf::Stack.const_get(cname)
      rescue => e
        # Try dynamic_load only once
        fail <<-EOS.rm_spacepipe unless first
          |Error! class not found
          | * Name: #{cname}
        EOS
        first = false
        Pf::Stack.dynamic_load(cname)
        retry
      end
      return cls
    end

    STACK_DIR = File.join(File.dirname(__dir__), "pf/stack")
    fail <<-EOS.rm_spacepipe unless Dir.exists?(STACK_DIR)
      |Error! file or directory not found
      | * Path : #{STACK_DIR}
    EOS

    @@rb_script_loaded = []

    def self.dynamic_load(cname)
      pattern = cname.scan(/[A-Z][^A-Z]*/).map(&:downcase).join('[-_]')
      pattern = File.join(STACK_DIR, "**", pattern + '.rb')
      Dir.glob(pattern).compact.tap{|files|
        # If found 2 or more files, error at here.
        fail <<-EOS.rm_spacepipe if files.size > 1
          |Error! multiple module definition are found. Please distinguish '-' from '_'.
          | * Name: #{cname}
          | * Matched: ->#{files.join('\n')}<-
        EOS
        # If not found, error at here.
        fail <<-EOS.rm_spacepipe if files.size == 0
          |Error! no module definition is found. Please check whether it is correct or not.
          | * Name: #{cname}
        EOS
      }.select{|rbfile|
        not @@rb_script_loaded.include?(rbfile)
      }.each{|rbfile|
        $LOAD_PATH.unshift(STACK_DIR)
        load rbfile
        $LOAD_PATH.shift
        @@rb_script_loaded << rbfile
      }
    end

  end
end
