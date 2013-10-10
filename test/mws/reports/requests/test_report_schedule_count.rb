require 'request_helper'
require 'mws/reports/requests/report_schedule_count'

class ReportScheduleCountRequestTest < RequestTest
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
    @count = MWS::Reports::Requests::ReportScheduleCount.new(mock_client)
  end

  def test_gets_report_schedule_count
    assert_equal 1, @count.get.to_i
  end
end
