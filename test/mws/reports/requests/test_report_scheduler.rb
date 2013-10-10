require 'request_helper'
require 'mws/reports/requests/report_scheduler'

class ReportSchedulerRequestTest < RequestTest
  def mock_response_body
    <<-EOF
      <Response xmlns="ns">
        <Result>
          <Count>1</Count>
          <ReportSchedule>
            <ReportType>_GET_ORDERS_DATA_</ReportType>
            <Schedule>_30_DAYS_</Schedule>
            <ScheduledDate>2009-02-20T02:10:42+00:00</ScheduledDate>
          </ReportSchedule>
        </Response>
      </Result>
    EOF
  end

  def setup
    @scheduler = MWS::Reports::Requests::ReportScheduler.new(mock_client)
  end

  def test_manages_report_schedule
    res = @scheduler.manage('_GET_ORDERS_DATA_', '_1_HOUR_')
    assert_kind_of MWS::Reports::Parsers::ReportScheduler, res
  end

  def test_deletes_report_schedule
    res = @scheduler.delete('_GET_ORDERS_DATA_')
    assert_kind_of MWS::Reports::Parsers::ReportScheduler, res
  end
end
