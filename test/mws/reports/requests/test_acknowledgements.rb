require 'request_helper'
require 'mws/reports/requests/report_acknowledgements'

class ReportAcknowledgementsTest < RequestTest
  def mock_response_body
    <<-EOF
      <Response xmlns="ns">
        <Result>
          <Count>1</Count>
          <ReportInfo>
            <ReportId>841997483</ReportId>
            <ReportType>_GET_MERCHANT_LISTINGS_DATA_</ReportType>
            <ReportRequestId>2234038326</ReportRequestId>
            <AvailableDate>2009-01-06T03:48:36+00:00</AvailableDate>
            <Acknowledged>true</Acknowledged>
            <AcknowledgedDate>2009-02-20T02:10:41+00:00</AcknowledgedDate>
          </ReportInfo>
        </Result>
      </Response>
    EOF
  end

  def setup
    @report = MWS::Reports::Requests::ReportAcknowledgements.new(mock_client)
  end

  def test_acknowledges_reports
    res = @report.acknowledge('123')
    refute_empty res
  end

  def test_unacknowledges_reports
    res = @report.unacknowledge('123')
    refute_empty res
  end
end
