require  'parser_helper'
require 'mws/feeds/parsers/feed_submission_list'

class FeedSubmissionListParserTest < ParserTest
  def setup
    node = fixture('feeds/feed_submission_list').xpath('//xmlns:GetFeedSubmissionListResult')
    @feed_submission_list = MWS::Feeds::Parsers::FeedSubmissionList.new(node)
  end

  def test_has_feed_submission_list
    refute_empty @feed_submission_list.to_a
    @feed_submission_list.each { |feed| assert_kind_of MWS::Feeds::Parsers::FeedSubmission, feed }
  end
end
