require 'test_helper'
require 'mws/feeds/client'

class TestFeedsClient < MiniTest::Test
  def setup
    @client = MWS::Feeds::Client.new
  end

  def test_submit_feed_has_marketplace_id_list
    @client.stub(:run, nil) do
      @client.marketplace_id = 'A1F83G8C2ARO7P'
      @client.submit_feed('content', 'type', marketplace_id_list: '1')
      @client.operation.key?('MarketplaceIdList.Id.1')
    end
  end

  def test_get_feed_submission_list_has_feed_submission_id_list
    @client.stub(:run, nil) do
      @client.get_feed_submission_list(feed_submission_id_list: '1')
      @client.operation.key?('FeedSubmissionIdList.Status.1')
    end
  end

  def test_get_feed_submission_list_has_feed_type_list
    @client.stub(:run, nil) do
      @client.get_feed_submission_list(feed_type_list: '1')
      @client.operation.key?('FeedTypeList.Type.1')
    end
  end

  def test_get_feed_submission_list_has_feed_processing_status_list
    @client.stub(:run, nil) do
      @client.get_feed_submission_list(feed_processing_status_list: '1')
      @client.operation.key?('FeedProcessingStatusList.Status.1')
    end
  end

  def test_get_feed_submission_count_has_feed_type_list
    @client.stub(:run, nil) do
      @client.get_feed_submission_count(feed_type_list: '1')
      @client.operation.key?('FeedTypeList.Type.1')
    end
  end

  def test_get_feed_submission_count_has_feed_processing_status_list
    @client.stub(:run, nil) do
      @client.get_feed_submission_count(feed_processing_status_list: '1')
      @client.operation.key?('FeedProcessingStatusList.Status.1')
    end
  end
end
