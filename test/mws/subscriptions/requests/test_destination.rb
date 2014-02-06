require 'request_helper'
require 'mws/subscriptions/requests/destination'

class MWSDestinationServiceStatusRequestTest < RequestTest
  def mock_response_body
    <<-EOF
      <Response xmlns="ns">
        <Result>
        </Result>
        <RequestId>123</RequestId>
      </Response>
    EOF
  end

  def setup
    @destination = MWS::Subscriptions::Requests::Destination.new(mock_client)
  end

  def test_registers
    res = @destination.register('destination')
    assert_kind_of MWS::Subscriptions::Parsers::Destination, res
  end

  def test_deregisters
    res = @destination.deregister('destination')
    assert_kind_of MWS::Subscriptions::Parsers::Destination, res
  end

  def test_sends_test_notification
    res = @destination.send_test_notification_to('destination')
    assert_kind_of MWS::Subscriptions::Parsers::Destination, res
  end
end
