require 'request_helper'
require 'mws/reports/requests/report_list'

class ReportListRequestTest < RequestTest
  def mock_response_body
    <<-EOF
      <Response xmlns="ns">
        <Result>
        <NextToken>2YgYW55IPQhvu5hbCBwbGVhc3VyZS4=</NextToken>
          <HasNext>true</HasNext>
          <ReportInfo>
            <ReportId>898899473</ReportId>
            <ReportType>_GET_MERCHANT_LISTINGS_DATA_</ReportType>
            <ReportRequestId>2278662938</ReportRequestId>
            <AvailableDate>2009-02-10T09:22:33+00:00</AvailableDate>
            <Acknowledged>false</Acknowledged>
          </ReportInfo>
        </Result>
      </Response>
    EOF
  end

  def setup
    @reports = MWS::Reports::Requests::ReportList.new(mock_client)
  end

  def test_gets_report_list
    res = @reports.get
    assert_kind_of MWS::Reports::Parsers::ReportList, res
  end

  def test_gets_report_list_by_next_token
    mock_parsed_response = MiniTest::Mock.new
    mock_parsed_response.expect(:next_token, '123')
    @reports.last_parsed_response = mock_parsed_response
    res = @reports.get_by_next_token
    assert_kind_of MWS::Reports::Parsers::ReportList, res
  end
end
