require 'request_helper'
require 'mws/orders/requests/service_status'

class MWSOrdersServiceStatusRequestTest < RequestTest
  def mock_response_body
    <<-EOF
      <Response xmlns="ns">
        <GetServiceStatusResult>
          <Status>GREEN</Status>
        </GetServiceStatusResult>
      </Response>
    EOF
  end

  def setup
    @status = MWS::Orders::Requests::ServiceStatus.new(mock_client)
  end

  def test_gets_status
    res = @status.get
    assert_kind_of MWS::Orders::Parsers::ServiceStatus, res
  end
end
