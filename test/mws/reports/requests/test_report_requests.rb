require 'request_helper'
require 'mws/reports/requests/report_requests'

class ReportRequestsRequesttTest < RequestTest
  def mock_response_body
    <<-EOF
      <Response xmlns="ns">
        <Result>
          <Count>1</Count>
          <ReportRequestInfo>
            <ReportRequestId>123456</ReportRequestId>
            <FeedType>_POST_PRODUCT_DATA_</FeedType>
            <SubmittedDate>2009-02-20T02:10:35+00:00</SubmittedDate>
            <FeedProcessingStatus>_CANCELLED_</FeedProcessingStatus>
          </ReportRequestInfo>
        </Result>
      </Response>
    EOF
  end

  def setup
    @reports = MWS::Reports::Requests::ReportRequests.new(mock_client)
  end

  def test_cancels_feedback_submissions
    res = @reports.cancel(submitted_from_date: 0)
    assert_kind_of MWS::Reports::Parsers::ReportRequests, res
  end
end
