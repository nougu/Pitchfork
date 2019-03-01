require 'test/unit'

class PfTest < Test::Unit::TestCase
  data(
    'thin-vol'  => ['example/thin-vol.yml', '/dev/mapper/thin-vol'],
    'thin-vol'  => ['example/thin-vol.yml', '/dev/mapper/thin-vol'],
    'thin-snap' => ['example/thin-snap.yml', '/dev/mapper/snap1']
  )
  test "simple seal" do |(yml,dev)|
    assert(File.exists?(yml))

    # cleanup device stack
    `pf build #{yml} 2> /dev/null` unless File.exists?(dev)
    assert(File.exists?(dev))
 
    # try destroy with seal top_of_stack (means NOBODY will be destroyed)
    `pf seal #{yml} #{dev} | pf destroy -`
    assert(File.exists?(dev))

    # try destroy without seal (means all will be destroyed)
    `pf destroy #{yml}`
    assert(!File.exists?(dev))
  end
end
