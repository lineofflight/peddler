require 'request_helper'
require 'mws/subscriptions/requests/service_status'

class MWSSubscriptionsServiceStatusRequestTest < RequestTest
  def mock_response_body
    <<-EOF
      <Response xmlns="ns">
        <Result>
          <GetServiceStatusResult>
            <Status>GREEN</Status>
          </GetServiceStatusResult>
        </Result>
      </Response>
    EOF
  end

  def setup
    @status = MWS::Subscriptions::Requests::ServiceStatus.new(mock_client)
  end

  def test_gets_status
    res = @status.get
    assert_kind_of MWS::Subscriptions::Parsers::ServiceStatus, res
  end
end
