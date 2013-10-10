require 'request_helper'
require 'mws/reports/requests/report_request_info'

class ReportRequestInfoTest < RequestTest
  def mock_response_body
    <<-EOF
      <Result xmlns="ns">
        <ReportRequestInfo>
          <ReportRequestId>2291326454</ReportRequestId>
          <ReportType>_GET_MERCHANT_LISTINGS_DATA_</ReportType>
          <StartDate>2009-01-21T02:10:39+00:00</StartDate>
          <EndDate>2009-02-13T02:10:39+00:00</EndDate>
          <Scheduled>false</Scheduled>
          <SubmittedDate>2009-02-20T02:10:39+00:00</SubmittedDate>
          <ReportProcessingStatus>_SUBMITTED_</ReportProcessingStatus>
        </ReportRequestInfo>
      </Result>
    EOF
  end

  def setup
    @report = MWS::Reports::Requests::ReportRequestInfo.new(mock_client)
  end

  def test_requests_report
    res = @report.request('_GET_FLAT_FILE_OPEN_LISTINGS_DATA_')
    assert_kind_of MWS::Reports::Parsers::ReportRequestInfo, res
  end
end
