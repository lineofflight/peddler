require 'helper'
require 'peddler/xml_parser'

class TestPeddlerXMLParser < MiniTest::Test
  Parser = Class.new(::Peddler::XMLParser)

  def setup
    body = '<Foo>Bar</Foo>'

    res = OpenStruct.new(
      body: body,
      headers: {
        'Content-Type' => 'text/xml',
        'Content-Length' => body.size.to_s
      }
    )

    @parser = Parser.new(res)
  end

  def test_does_not_implement_parsing
    assert_raises NotImplementedError do
      @parser.parse
    end
  end

  def test_digs_data
    @parser.instance_variable_set :@data, foo: { bar: :baz }
    assert_equal :baz, @parser.dig(:foo, :bar)
  end

  def test_validates
    assert @parser.valid?
  end
end
