require  'parser_helper'
require 'mws/feeds/parsers/feed_submission'

class FeedParserTest < ParserTest
  def setup
    node = fixture('feeds/feed_submission').xpath('//xmlns:FeedSubmissionInfo').first
    @feed = MWS::Feeds::Parsers::FeedSubmission.new(node)
  end

  def test_id
    assert_kind_of String, @feed.id
  end

  def test_type
    assert_kind_of String, @feed.type
  end

  def test_submitted_at
    assert_kind_of Time, @feed.submitted_at
  end

  def test_processing_status
    assert_kind_of String, @feed.processing_status
  end
end
