require 'helper'
require 'peddler/error_parser'

class TestPeddlerErrorParser < MiniTest::Test
  def setup
    body = <<-XML
      <ErrorResponse>
        <Error>
          <Type>Foo</Type>
          <Code>Bar</Code>
          <Message>Baz</Message>
        </Error>
        <RequestID>123</RequestID>
      </ErrorResponse>
    XML
    res = OpenStruct.new(
      body: body,
      headers: {
        'Content-Type' => 'text/xml',
        'Content-Length' => body.size.to_s
      }
    )

    @parser = Peddler::ErrorParser.new(res)
  end

  def test_parses_data
    assert @parser.parse
  end

  def test_has_a_message
    assert @parser.message
  end

  def test_has_code
    assert @parser.code
  end

  def test_has_type
    assert @parser.type
  end
end
