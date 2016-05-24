require 'integration_helper'
require 'mws/orders'
require 'peddler/errors/handler'

class TestErrors < IntegrationTest
  def setup
    @previous_error_handler = MWS::Orders::Client.error_handler
    MWS::Orders::Client.error_handler = Peddler::Errors::Handler
    @api = 'Orders'
    super
  end

  def teardown
    MWS::Orders::Client.error_handler = @previous_error_handler
    super
  end

  def test_invalid_key
    clients.each do |client|
      e = assert_raises Peddler::Errors::Error do
        client.aws_access_key_id = 'foo'
        client.get_order('bar')
      end
      assert_instance_of Peddler::Errors::InvalidAccessKeyId, e
    end
  end

  def test_request_throttled
    clients.each do |client|
      e = assert_raises Peddler::Errors::Error do
        client.get_order('foo')
      end
      assert_instance_of Peddler::Errors::RequestThrottled, e
    end
  end
end
