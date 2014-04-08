require 'helper'
require 'peddler'

class PeddlerTest < MiniTest::Test
  def test_loads_all_apis
    assert_equal 13, MWS.constants.size
  end
end
