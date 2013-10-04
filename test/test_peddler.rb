require 'helper'
require 'peddler'

class PeddlerTest < MiniTest::Test
  def test_loads_apis
    assert_equal 11, MWS.constants.size
  end
end
