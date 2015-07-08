require 'helper'
require 'peddler/xml_response_parser'

class TestPeddlerXMLResponseParser < MiniTest::Test
  def setup
    body = '<Response><Result><NextToken>123</NextToken>'\
           '<Foo>Bar</Foo></Result></Response>'
    res = OpenStruct.new(
      body: body,
      headers: { 'Content-Type' => 'text/xml', 'Content-Length' => '78' }
    )

    @parser = Peddler::XMLResponseParser.new(res)
  end

  def test_parses_data
    assert_equal 'Bar', @parser.parse['Foo']
  end

  def test_next_token
    assert_equal '123', @parser.next_token
  end
end
