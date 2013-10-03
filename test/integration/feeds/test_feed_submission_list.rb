require 'integration_helper'
require 'mws/feeds'

class FeedsTest < IntegrationTest
  self.api = MWS::Feeds

  def test_gets_feed_submission_list
    @clients.each do |client|
      feeds = client.get_feed_submission_list
      refute_empty feeds.to_a
      more_feeds = client.get_feed_submission_list_by_next_token
      refute_empty more_feeds.to_a
    end
  end
end
