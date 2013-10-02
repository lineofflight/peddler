require 'parser_helper'
require 'mws/orders/parsers/payment_execution_detail_item'

class PaymentExecutionDetailItemParserTest < ParserTest
  def setup
    node = fixture('orders/orders').xpath('//xmlns:PaymentExecutionDetailItem').first
    @pedi = MWS::Orders::Parsers::PaymentExecutionDetailItem.new(node)
  end

  def test_payment
    assert_kind_of Money, @pedi.payment
  end

  def test_payment_method
    assert_kind_of String, @pedi.payment_method
  end
end
