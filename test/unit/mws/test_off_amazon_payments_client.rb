require 'test_helper'
require 'mws/off_amazon_payments/client'

class TestMWSOffAmazonPaymentsClient < MiniTest::Test
  def setup
    @client = MWS::OffAmazonPayments::Client.new
  end

  def test_sandbox
    @client.marketplace_id = 'A1F83G8C2ARO7P'
    refute_includes @client.aws_endpoint, 'Sandbox'
    assert_includes @client.sandbox.aws_endpoint, 'Sandbox'
  end

  def test_gets_capture_details
    @client.stub(:run, nil) do
      @client.get_capture_details('1')
      assert_equal 'GetCaptureDetails', @client.operation.fetch('Action')
      assert_equal '1', @client.operation.fetch('AmazonCaptureId')
    end
  end
end
