#
# Monkey-patching extensions
# 
# XXX
#   These functions would be gone away in the future
#   to avoid an illness caused by global side effect.
#
class String
  def rm_spacepipe
    "\n" + self.gsub(/^\s+\|/,'')
  end
end
