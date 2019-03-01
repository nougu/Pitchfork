require 'test/unit'

class PfTest < Test::Unit::TestCase
  data(
    'leaf'      => ['example/leaf.yml', '/dev/mapper/thin-vol'],
    'thin-vol'  => ['example/thin-vol.yml', '/dev/mapper/thin-vol'],
    'thin-snap' => ['example/thin-snap.yml', '/dev/mapper/snap1']
  )
  test "simple build & destroy" do |(yml,dev)|
    assert(File.exists?(yml))

    # cleanup device stack
    `pf destroy #{yml} 2> /dev/null` if File.exists?(dev)
    assert(!File.exists?(dev))

    # now build a stack
    `pf build #{yml}`
    assert(File.exists?(dev))

    # destroy a stack
    `pf destroy #{yml}`
    assert(!File.exists?(dev))
  end
end
