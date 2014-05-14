require 'helper'
require 'mws'

class MWSTest < MiniTest::Test
  def test_delegates_to_apis
    assert_equal MWS.methods(false).size, MWS.constants.size
  end
end
