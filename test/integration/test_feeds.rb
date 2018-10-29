# frozen_string_literal: true

require 'integration_helper'
require 'mws/feeds'

class TestFeeds < IntegrationTest
  def test_getting_feed_submission_count
    clients.each do |client|
      res = client.get_feed_submission_count
      refute_empty res.parse
    end
  end

  def test_getting_feed_submission_list
    clients.each do |client|
      res = client.get_feed_submission_list
      refute_empty res.parse
    end
  end

  def test_submitting_feeds
    feed_content = "sku\tprice\tquantity\nwidget\t\t0\n"
    feed_type = '_POST_FLAT_FILE_PRICEANDQUANTITYONLY_UPDATE_DATA_'

    clients.each do |client|
      res = client.submit_feed(feed_content, feed_type)
      feed_submission_id = res.dig('FeedSubmissionInfo', 'FeedSubmissionId')
      assert feed_submission_id

      # Clean up
      client.cancel_feed_submissions(
        feed_submission_id: feed_submission_id,
        feed_type_list: feed_type
      )
    end
  end
end
