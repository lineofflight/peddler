require 'integration_helper'
require 'mws/feeds'

class FeedSubmissionCountTest < IntegrationTest
  self.api = MWS::Feeds

  def test_gets_feed_submission_count
    VCR.use_cassette('feed_submission_count_test/test_gets_feed_submission_count') do
      @clients.each do |client|
        res = client.get_feed_submission_count
        assert_kind_of Integer, res.count
      end
    end
  end
end
