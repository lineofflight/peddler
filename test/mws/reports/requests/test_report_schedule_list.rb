require 'request_helper'
require 'mws/reports/requests/report_schedule_list'

class ReportScheduleListRequestTest < RequestTest
  def mock_response_body
    <<-EOF
      <Response xmlns="ns">
        <Result>
          <NextToken></NextToken>
          <HasNext>false</HasNext>
          <ReportRequestInfo>
          <ReportSchedule>
            <ReportType>_GET_ORDERS_DATA_</ReportType>
            <Schedule>_30_DAYS_</Schedule>
            <ScheduledDate>2009-02-20T02:10:42+00:00</ScheduledDate>
          </ReportSchedule>
        </Result>
      </Response>
    EOF
  end

  def setup
    @list = MWS::Reports::Requests::ReportScheduleList.new(mock_client)
  end

  def test_gets_report_request_list
    res = @list.get
    assert_kind_of MWS::Reports::Parsers::ReportScheduleList, res
  end

  def test_gets_report_request_list_by_next_token
    assert_raises(NotImplementedError) {
      @list.get_by_next_token
    }
  end
end
