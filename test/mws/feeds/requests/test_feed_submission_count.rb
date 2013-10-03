require 'request_helper'
require 'mws/feeds/requests/feed_submission_count'

class FeedSubmissionCountRequestTest < RequestTest
  def mock_response_body
    <<-EOF
      <Response xmlns="ns">
        <Result>
          <Count>1</Count>
        </Response>
      </Result>
    EOF
  end

  def setup
    @feeds = MWS::Feeds::Requests::FeedSubmissionCount.new(mock_client)
  end

  def test_gets_feed_submission_count
    res = @feeds.get(submitted_from_date: 0)
    assert_equal 1, res.count
  end
end
