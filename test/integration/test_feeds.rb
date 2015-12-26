require 'helper'
require 'mws/feeds'

class TestFeeds < IntegrationTest
  def test_gets_feed_submission_count
    clients.each do |client|
      res = client.get_feed_submission_count
      refute_empty res.parse
    end
  end

  def test_gets_feed_submission_list
    clients.each do |client|
      res = client.get_feed_submission_list
      refute_empty res.parse
    end
  end

  def test_submits_feeds
    content = "sku\tprice\tquantity\nwidget\t\t0\n"
    type = '_POST_FLAT_FILE_PRICEANDQUANTITYONLY_UPDATE_DATA_'

    clients.each do |client|
      res = client.submit_feed(content, type)
      id = res.parse['FeedSubmissionInfo']['FeedSubmissionId']
      refute_nil id

      # Clean up
      client.body = nil
      client.cancel_feed_submissions(
        feed_submission_id: id,
        feed_type_list: type
      )
    end
  end
end
