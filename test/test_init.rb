require 'test/unit'

class PfTest < Test::Unit::TestCase
  data do
    mods = %w(
      command
      dm_cache
      dm_crypt
      dm_linear
      dm_snapshot
      dm_thin_pool
      dm_thin_snap
      dm_thin_thin
      dm_zero
      flashcache
      leaf
      loopback
      md
      nbd_client
      nbd_server
      stgt
    )
    Hash[mods.zip(mods)]
  end
  test "simple init" do |(mod,_)|
    `echo '- #{mod}' | pf init - | wc -l`
    assert($?.success?)
  end
end
