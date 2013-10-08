require 'request_helper'
require 'mws/reports/requests/report_request_count'

class ReportRequestCountRequestTest < RequestTest
  def mock_response_body
    <<-EOF
      <Response xmlns="ns">
        <Result>
          <Count>1</Count>
        </Response>
      </Result>
    EOF
  end

  def setup
    @count = MWS::Reports::Requests::ReportRequestCount.new(mock_client)
  end

  def test_gets_report_request_count
    res = @count.get(submitted_from_date: 0)
    assert_equal 1, res.count
  end
end
