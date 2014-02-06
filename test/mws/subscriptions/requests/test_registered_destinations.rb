require 'request_helper'
require 'mws/subscriptions/requests/registered_destinations'

class MWSRegisteredDestinationsServiceStatusRequestTest < RequestTest
  def mock_response_body
    <<-EOF
      <Response xmlns="ns">
        <Result>
          <DestinationList>
            <member>
              <DeliveryChannel>SQS</DeliveryChannel>
              <AttributeList>
                <member>
                  <Value>https://sqs.us-east-1.amazonaws.com/123/mws_notifications</Value>
                  <Key>sqsQueueUrl</Key>
                </member>
              </AttributeList>
            </member>
          </DestinationList>
        </Result>
        <RequestId>123</RequestId>
      </Response>
    EOF
  end

  def setup
    @destinations = MWS::Subscriptions::Requests::RegisteredDestinations.new(mock_client)
  end

  def test_lists
    res = @destinations.list
    assert_kind_of MWS::Subscriptions::Parsers::RegisteredDestinations, res
  end
end
