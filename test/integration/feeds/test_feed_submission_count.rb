require 'integration_helper'
require 'mws/feeds'

class FeedSubmissionCountTest < IntegrationTest
  self.api = MWS::Feeds

  def test_gets_feed_submission_count
    @clients.each do |client|
      res = client.get_feed_submission_count
      assert_kind_of Integer, res.count
    end
  end
end
