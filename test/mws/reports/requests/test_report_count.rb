require 'request_helper'
require 'mws/reports/requests/report_count'

class ReportCountRequestTest < RequestTest
  def mock_response_body
    <<-EOF
      <Response xmlns="ns">
        <Result>
          <Count>1</Count>
        </Result>
      </Response>
    EOF
  end

  def setup
    @count = MWS::Reports::Requests::ReportCount.new(mock_client)
  end

  def test_gets_report_count
    res = @count.get
    assert_equal 1, res.count
  end
end
