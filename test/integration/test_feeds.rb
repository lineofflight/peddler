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
end
