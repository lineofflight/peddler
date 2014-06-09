require 'helper'
require 'mws/order_reference_object'

class MWSOAPObjectTest < MiniTest::Test
  def test_initialization
    oro = MWS::OAPObject.new('blah')
    assert_equal oro.id, 'blah'
    assert oro.api.instance_of?(MWS::OffAmazonPayments)
  end
end
