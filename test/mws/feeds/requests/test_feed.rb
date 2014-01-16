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
        </Result>
      </Response>
    EOF
  end

  def setup
    @feed = MWS::Feeds::Requests::Feed.new(mock_client)
  end

  def test_submits_flat_file
    @feed.client.expect(:default_country, 'US')
    res = @feed.submit('foo', '_POST_FLAT_FILE_DATA_')
    assert_kind_of MWS::Feeds::Parsers::Feed, res
  end

  def test_submits_xml
    @feed.client.expect(:default_country, 'US')
    xml = '<?xml version="1.0"?><Foo></Foo>'
    res = @feed.submit(xml, '_POST_XML_DATA_')
    assert_kind_of MWS::Feeds::Parsers::Feed, res
  end

  def test_headers_for_latin_flat_file
    @feed.client.expect(:default_country, 'US')
    @feed.body = 'foo'
    @feed.set_content_type
    assert_equal "text/tab-separated-values; charset=ISO-8859-1", @feed.headers.fetch('Content-Type')
  end

  def test_headers_for_chinese_flat_file
    @feed.client.expect(:default_country, 'CN')
    @feed.body = 'foo'
    @feed.set_content_type
    assert_equal 'text/tab-separated-values; charset=UTF-16', @feed.headers.fetch('Content-Type')
  end

  def test_headers_for_japanese_flat_file
    @feed.client.expect(:default_country, 'JP')
    @feed.body = 'foo'
    @feed.set_content_type
    assert_equal 'text/tab-separated-values; charset=Shift_JIS', @feed.headers.fetch('Content-Type')
  end

  def test_headers_for_xml
    @feed.body = '<?xml version="1.0"?><Foo></Foo>'
    @feed.set_content_type
    assert_equal 'text/xml; charset=ISO-8859-1', @feed.headers.fetch('Content-Type')
  end
end
