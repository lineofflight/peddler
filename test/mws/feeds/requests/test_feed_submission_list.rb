require 'request_helper'
require 'mws/feeds/requests/feed_submission_list'

class FeedSubmissionListRequestTest < RequestTest
  def mock_response_body
    <<-EOF
      <Response xmlns="ns">
        <Result>
          <NextToken>123</NextToken>
          <FeedSubmissionInfo>
            <FeedSubmissionId>123456</FeedSubmissionId>
            <FeedType>_POST_PRODUCT_DATA_</FeedType>
            <SubmittedDate>2009-02-20T02:10:35+00:00</SubmittedDate>
            <FeedProcessingStatus>_SUBMITTED_</FeedProcessingStatus>
          </FeedSubmissionInfo>
        </Response>
      </Result>
    EOF
  end

  def setup
    @feeds = MWS::Feeds::Requests::FeedSubmissionList.new(mock_client)
  end

  def test_gets_feed_submission_list
    res = @feeds.get(submitted_from_date: 0)
    assert_kind_of MWS::Feeds::Parsers::FeedSubmissionList, res
  end

  def test_returns_next_token
    @feeds.last_response = mock_response
    assert_equal '123', @feeds.next_token
  end

  def test_gets_feed_submission_list_by_next_token
    @feeds.last_response = mock_response
    res = @feeds.get_by_next_token
    assert_kind_of MWS::Feeds::Parsers::FeedSubmissionList, res
  end
end
