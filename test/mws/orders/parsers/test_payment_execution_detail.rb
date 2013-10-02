require 'parser_helper'
require 'mws/orders/parsers/payment_execution_detail'

class PaymentExecutionDetailParserTest < ParserTest
  def setup
    node = fixture('orders').xpath('//xmlns:PaymentExecutionDetail').first
    @ped = MWS::Orders::Parsers::PaymentExecutionDetail.new(node)
  end

  def test_has_payment_execution_detail_items
    refute_empty @ped.to_a
    @ped.each { |pedi| assert_kind_of MWS::Orders::Parsers::PaymentExecutionDetailItem, pedi }
  end
end
