require 'integration_helper'
require 'mws/feeds'

class FeedSubmissionResultTest < IntegrationTest
  self.api = MWS::Feeds

  def test_gets_feed_submission_result
    VCR.use_cassette('feed_submission_result_test/test_gets_feed_submission_result') do
      @clients.each do |client|
        feeds = client.get_feed_submission_list(feed_processing_status_list: '_DONE_', max_count: 1)
        feed_submission_id = feeds.first.id
        result = client.get_feed_submission_result(feed_submission_id)
        refute_empty result.to_s
      end
    end
  end
end
