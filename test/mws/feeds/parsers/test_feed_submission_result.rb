require 'parser_helper'
require 'mws/feeds/parsers/feed_submission_result'

class FeedSubmissionResultParserTest < ParserTest
  def setup
    @body = 'foo'
    @result = MWS::Feeds::Parsers::FeedSubmissionResult.new(@body)
  end

  def test_content
    assert_equal @body, @result.document
  end
end
