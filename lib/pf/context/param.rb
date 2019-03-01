module Pf
  module Param
    def fetch_path(key, nilable: false)
      param = self.fetch(key) {
        return nil if nilable
        fail "Missing parameter in YAML: #{key}"
      }
      param.is_a?(Hash) ? param.fetch("Path") : param
    end

    def fetch_paths(key, nilable: false)
      params = self.fetch(key) {
        return nil if nilable
        fail "Missing parameter in YAML: #{key}"
      }
      params.map{|param|
        param.is_a?(Hash) ? param.fetch("Path") : param
      }
    end

    def fetch_size(key, path)
      self.fetch(key) {
        if File.exists?(path)
          if File.blockdev?(path)
            return `blockdev --getsz #{path} 2> /dev/null`.to_i
          else
            return `du -b -s #{path} 2> /dev/null | cut -f1`.to_i
          end
        else
          # get size of device at runtime
          return "$(blockdev --getsz #{path})"
        end
      }
    end
  end
end
