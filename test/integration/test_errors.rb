# frozen_string_literal: true

require 'integration_helper'
require 'mws/orders'

class TestErrors < IntegrationTest
  use 'Orders'

  def test_invalid_key
    clients.each do |client|
      assert_raises(Peddler::Errors::InvalidAccessKeyId) do
        client.aws_access_key_id = 'foo'
        client.get_order('bar')
      end
    end
  end

  def test_request_throttled
    clients.each do |client|
      assert_raises(Peddler::Errors::RequestThrottled) do
        client.get_order('foo')
      end
    end
  end
end
