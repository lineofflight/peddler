require  'parser_helper'
require 'mws/feeds/parsers/feed_submission_count'

class FeedSubmissionCountParserTest < ParserTest
  def setup
    node = fixture('feeds/feed_submission_count').xpath('//xmlns:GetFeedSubmissionCountResult')
    @feeds = MWS::Feeds::Parsers::FeedSubmissionCount.new(node)
  end

  def test_feed_submission_count
    assert_kind_of Integer, @feeds.count
  end
end
