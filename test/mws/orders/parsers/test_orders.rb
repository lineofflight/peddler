require 'parser_helper'
require 'mws/orders/parsers/orders'

class OrdersParserTest < ParserTest
  def setup
    node = fixture('orders/orders').xpath('//xmlns:ListOrdersResult')
    @orders = MWS::Orders::Parsers::Orders.new(node)
  end

  def test_has_orders
    refute_empty @orders.to_a
    @orders.each { |order| assert_kind_of MWS::Orders::Parsers::Order, order }
  end

  def test_has_token
    assert @orders.has_next_token?
  end
end
