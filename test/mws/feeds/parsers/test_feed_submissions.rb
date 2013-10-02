require  'parser_helper'
require 'mws/feeds/parsers/feed_submissions'

class FeedSubmissionsParserTest < ParserTest
  def setup
    node = fixture('feeds/feed_submission_list').xpath('//xmlns:GetFeedSubmissionListResult')
    @feed_submissions = MWS::Feeds::Parsers::FeedSubmissions.new(node)
  end

  def test_has_feed_submissions
    refute_empty @feed_submissions.to_a
    @feed_submissions.each { |feed| assert_kind_of MWS::Feeds::Parsers::FeedSubmission, feed }
  end
end
