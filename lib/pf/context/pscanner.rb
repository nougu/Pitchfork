module Pf
  class ParamScanner
    def initialize(v)
      @value = v
    end

    def [](key)
      fetch(key)
    end

    def []=(key,value)
      #@hash[key] = value
    end

    def fetch(key, defval = nil, &block)
      unless @value.is_a?(Hash)
        @value = {}
      end
      @value[key] = defval.nil? ? ParamScanner.new("< Fill a value >") : defval
    end

    def fetch_path(key, nilable: false)
      fetch(key, "< Fill a path string or reference >")
    end

    def fetch_paths(key, nilable: false)
      fetch(key, [ "< Fill path string(s) or reference(s) >" ])
    end

    def fetch_size(key, path)
      return `blockdev --getsz #{path} 2> /dev/null`.to_i if File.exists?(path)
    end

    def to_h
      return @value unless @value.is_a?(Hash)

      @value.inject({}){|ret,(key,val)|
        ret[key] = val.is_a?(ParamScanner) ? val.to_h : val
        ret
      }
    end
  end
end
