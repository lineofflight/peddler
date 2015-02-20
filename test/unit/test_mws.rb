require 'helper'
require 'mws'

class Test < MiniTest::Test
  def test_delegates_to_apis
    assert_equal MWS.methods(false).size, MWS.constants.size
    assert_kind_of MWS::Products::Client, MWS.products
  end
end
