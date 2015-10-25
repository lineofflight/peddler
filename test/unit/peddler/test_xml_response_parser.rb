require 'helper'
require 'peddler/xml_response_parser'

class TestPeddlerXMLResponseParser < MiniTest::Test
  def setup
    body = '<Response><Result><NextToken>123</NextToken>'\
           '<Foo>Bar</Foo></Result></Response>'

    @parser = Peddler::XMLResponseParser.new(response(body))
  end

  def response(body)
    OpenStruct.new(
      body: body,
      headers: { 'Content-Type' => 'text/xml', 'Content-Length' => '78' }
    )
  end

  def test_parses_data
    assert_equal 'Bar', @parser.parse['Foo']
  end

  def test_parses_message_data
    body_with_message = '<Response><Message><NextToken>123</NextToken>'\
           '<Foo>Bar</Foo></Message></Response>'
    parser = Peddler::XMLResponseParser.new(response(body_with_message))
    assert_equal 'Bar', parser.parse['Foo']
  end

  def test_next_token
    assert_equal '123', @parser.next_token
  end
end
