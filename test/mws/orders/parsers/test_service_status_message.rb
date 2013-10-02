require 'parser_helper'
require 'mws/orders/parsers/service_status_message'

class ServiceStatusMessageParserTest < ParserTest
  def setup
    node = fixture('orders/service_status').xpath('//xmlns:Message').first
    @message = MWS::Orders::Parsers::ServiceStatusMessage.new(node)
  end

  def test_locale
    assert_kind_of String, @message.locale
  end

  def test_text
    assert_kind_of String, @message.text
  end
end
