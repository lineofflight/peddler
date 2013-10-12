require 'request_helper'
require 'mws/sellers/requests/service_status'

class MWSSellersServiceStatusRequestTest < RequestTest
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
    @status = MWS::Sellers::Requests::ServiceStatus.new(mock_client)
  end

  def test_gets_status
    res = @status.get
    assert_kind_of MWS::Sellers::Parsers::ServiceStatus, res
  end
end
