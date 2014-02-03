require 'parser_helper'
require 'mws/feeds/parsers/feed_submission_result'

class FeedSubmissionResultParserTest < ParserTest
  def setup
    @node = fixture_from_cassette('feed_submission_result_test/test_gets_feed_submission_result', 1).xpath('//AmazonEnvelope')
    @result = MWS::Feeds::Parsers::FeedSubmissionResult.new(@node)
  end

  def test_content
    assert_equal @node, @result.document
  end

  def test_message_type
    assert_kind_of String, @result.message_type
  end

  def test_status_code
    assert_kind_of String, @result.status_code
  end
end
