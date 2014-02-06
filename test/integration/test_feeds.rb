require 'integration_helper'
require 'mws/feeds'

class FeedsTest < IntegrationTest
  self.api = MWS::Feeds

  def test_gets_feed_submission_count
    VCR.use_cassette('feeds/gets_feed_submission_count') do
      @clients.each do |client|
        res = client.get_feed_submission_count
        assert_kind_of Integer, res.count
      end
    end
  end

  def test_gets_feed_submission_list
    VCR.use_cassette('feeds/gets_feed_submission_list') do
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

  def test_gets_feed_submission_result
    VCR.use_cassette('feeds/gets_feed_submission_result') do
      @clients.each do |client|
        feeds = client.get_feed_submission_list(feed_processing_status_list: '_DONE_', max_count: 1)
        feed_submission_id = feeds.first.id
        result = client.get_feed_submission_result(feed_submission_id)
        refute_empty result.to_s
      end
    end
  end
end
