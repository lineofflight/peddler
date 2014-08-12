require 'test_helper'
require 'mws/off_amazon_payments/client'

class TestMWSOffAmazonPaymentsClient < MiniTest::Test
  def test_sandbox
    client = MWS::OffAmazonPayments::Client.new(marketplace_id: 'A1F83G8C2ARO7P').sandbox
    assert_includes client.aws_endpoint, 'OffAmazonPayments_Sandbox'
  end
end
