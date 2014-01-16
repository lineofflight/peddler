require 'request_helper'
require 'mws/reports/requests/report_request'

class ReportRequestSubmitTest < RequestTest
  def mock_response_body
    <<-EOF
      <Response xmlns="ns">
        <Result>
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
      </Response>
    EOF
  end

  def setup
    @report_request = MWS::Reports::Requests::ReportRequest.new(mock_client)
  end

  def test_submits_report_request
    res = @report_request.submit('_GET_MERCHANT_LISTINGS_DATA_')
    assert_kind_of MWS::Reports::Parsers::ReportRequest, res
  end
end
