require 'parser_helper'
require 'mws/feeds/parsers/feed_submissions'

class FeedSubmissionsParserTest < ParserTest
  def setup
    node = fixture('feeds/feed_submissions').xpath('//xmlns:CancelFeedSubmissionsResult')
    @cancelations = MWS::Feeds::Parsers::FeedSubmissions.new(node)
  end

  def test_cancelation_count
    assert_kind_of Integer, @cancelations.count
  end

  def test_canceled_feed_submissions
    refute_empty @cancelations.feed_submissions
  end
end
