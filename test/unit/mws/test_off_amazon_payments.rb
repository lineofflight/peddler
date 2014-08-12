require 'helper'
require 'mws/products'

class MWSOffAmazonPaymentsTest < MiniTest::Test
  def test_sandbox
    client = MWS::OffAmazonPayments::Client.new(marketplace_id: 'A1F83G8C2ARO7P').sandbox
    assert_includes client.aws_endpoint, 'OffAmazonPayments_Sandbox'
  end
end
