require 'request_helper'
require 'mws/reports/requests/report_request_list'

class ReportRequestListRequestTest < RequestTest
  def mock_response_body
    <<-EOF
      <Response xmlns="ns">
        <Result>
          <NextToken>123</NextToken>
          <ReportRequestInfo>
            <ReportRequestId>2291326454</ReportRequestId>
            <ReportType>_GET_MERCHANT_LISTINGS_DATA_</ReportType>
            <StartDate>2011-01-21T02:10:39+00:00</StartDate>
            <EndDate>2011-02-13T02:10:39+00:00</EndDate>
            <Scheduled>false</Scheduled>
            <SubmittedDate>2011-02-17T23:44:09+00:00</SubmittedDate>
            <ReportProcessingStatus>_DONE_</ReportProcessingStatus>
            <GeneratedReportId>3538561173</GeneratedReportId>
            <StartedProcessingDate>2011-02-17T23:44:43+00:00
            </StartedProcessingDate>
            <CompletedDate>2011-02-17T23:44:48+00:00</CompletedDate>
          </ReportRequestInfo>
        </Result>
      </Response>
    EOF
  end

  def setup
    @requests = MWS::Reports::Requests::ReportRequestList.new(mock_client)
  end

  def test_gets_report_request_list
    res = @requests.get(submitted_from_date: 0)
    assert_kind_of MWS::Reports::Parsers::ReportRequestList, res
  end

  def test_gets_report_request_list_by_next_token
    mock_parsed_response = MiniTest::Mock.new
    mock_parsed_response.expect(:next_token, '123')
    @requests.last_parsed_response = mock_parsed_response
    res = @requests.get_by_next_token
    assert_kind_of MWS::Reports::Parsers::ReportRequestList, res
  end
end
