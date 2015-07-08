require 'helper'
require 'peddler/xml_parser'

class TestPeddlerXMLParser < MiniTest::Test
  def setup
    body = '<Foo>Bar</Foo>'

    res = OpenStruct.new(
      body: body,
      headers: {
        'Content-Type' => 'text/xml',
        'Content-Length' => body.size.to_s
      }
    )

    @parser = Peddler::XMLParser.new(res)
  end

  def test_does_not_implement_parsing
    assert_raises NotImplementedError do
      @parser.parse
    end
  end

  def test_validates
    assert @parser.valid?
  end
end
