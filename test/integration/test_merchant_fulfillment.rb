require 'helper'
require 'mws/merchant_fulfillment'

class TestMerchantFulfillment < IntegrationTest
  def test_gets_service_status
    clients.each do |client|
      res = client.get_service_status
      refute_empty res.parse
    end
  end
end
