require 'request_helper'
require 'mws/feeds/requests/feed_submissions'

class FeedSubmissionsRequesttTest < RequestTest
  def mock_response_body
    <<-EOF
      <Response xmlns="ns">
        <Result>
          <Count>1</Count>
          <FeedSubmissionInfo>
            <FeedSubmissionId>123456</FeedSubmissionId>
            <FeedType>_POST_PRODUCT_DATA_</FeedType>
            <SubmittedDate>2009-02-20T02:10:35+00:00</SubmittedDate>
            <FeedProcessingStatus>_CANCELLED_</FeedProcessingStatus>
          </FeedSubmissionInfo>
        </Response>
      </Result>
    EOF
  end

  def setup
    @feeds = MWS::Feeds::Requests::FeedSubmissions.new(mock_client)
  end

  def test_cancels_feedback_submissions
    res = @feeds.cancel(submitted_from_date: 0)
    assert_kind_of MWS::Feeds::Parsers::FeedSubmissions, res
  end
end
