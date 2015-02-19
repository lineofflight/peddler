require 'test_helper'
require 'mws/subscriptions/client'

class TestSubscriptionsClient < MiniTest::Test
  def setup
    @client = MWS::Subscriptions::Client.new
  end

  def test_gets_service_status
    operation = {
      'Action' => 'GetServiceStatus'
    }

    @client.stub(:run, nil) do
      @client.get_service_status
    end

    assert_equal operation, @client.operation
  end

  # FIXME Fill in tests for operations
end
