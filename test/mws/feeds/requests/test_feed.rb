require 'request_helper'
require 'mws/feeds/requests/feed'

class FeedRequestTest < RequestTest
  def mock_response_body
    <<-EOF
      <Response xmlns="ns">
        <Result>
          <FeedSubmissionInfo>
            <FeedSubmissionId>123456</FeedSubmissionId>
            <FeedType>_POST_PRODUCT_DATA_</FeedType>
            <SubmittedDate>2009-02-20T02:10:35+00:00</SubmittedDate>
            <FeedProcessingStatus>_CANCELLED_</FeedProcessingStatus>
          </FeedSubmissionInfo>
        </Response>
      </Result>
    EOF
  end

  def setup
    @feed = MWS::Feeds::Requests::Feed.new(mock_client)
  end

  def test_submits
    @feed.client.expect(:default_country, 'US')
    res = @feed.submit('foo', '_POST_FLAT_FILE_INVLOADER_DATA_')
    assert_kind_of MWS::Feeds::Parsers::Feed, res
  end

  def test_latin_flat_file
    @feed.client.expect(:default_country, 'US')
    @feed.set_body('foo')
    assert_equal "text/tab-separated-values; charset=iso-8859-1", @feed.headers.fetch('Content-Type')
  end

  def test_chinese_flat_file
    @feed.client.expect(:default_country, 'CN')
    @feed.set_body('foo')
    assert_equal 'text/tab-separated-values; charset=UTF-16', @feed.headers.fetch('Content-Type')
  end

  def test_japanese_flat_file
    @feed.client.expect(:default_country, 'JP')
    @feed.set_body('foo')
    assert_equal 'text/tab-separated-values; charset=Shift_JIS', @feed.headers.fetch('Content-Type')
  end

  def test_submits_xml
    @feed.set_body('<?xml version="1.0"?><Foo></Foo>')
    assert_equal 'text/xml', @feed.headers.fetch('Content-Type')
  end
end
