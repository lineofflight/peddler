require 'parser_helper'
require 'mws/orders/parsers/order_items'

class OrderItemsParserTest < ParserTest
  def setup
    node = fixture('order_items').xpath('//xmlns:OrderItems')
    @order_items = MWS::Orders::Parsers::OrderItems.new(node)
  end

  def test_has_order_items
    refute_empty @order_items.to_a
    @order_items.each { |order_item| assert_kind_of MWS::Orders::Parsers::OrderItem, order_item }
  end
end
