require 'integration_helper'
require 'mws/feeds'

class FeedSubmissionListTest < IntegrationTest
  self.api = MWS::Feeds

  def test_gets_feed_submission_list
    VCR.use_cassette('feed_submission_list_test/test_gets_feed_submission_list') do
      @clients.each do |client|
        feeds = client.get_feed_submission_list
        refute_empty feeds.to_a
        more_feeds = client.get_feed_submission_list_by_next_token
        refute_empty more_feeds.to_a
        some_more_feeds = client.get_feed_submission_list_by_next_token(more_feeds.next_token)
        refute_empty some_more_feeds.to_a
      end
    end
  end
end
