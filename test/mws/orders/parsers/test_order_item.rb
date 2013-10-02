require 'parser_helper'
require 'mws/orders/parsers/order_item'

class OrderItemParserTest < ParserTest
  def setup
    node = fixture('orders/order_items').xpath('//xmlns:OrderItem').first
    @order_item = MWS::Orders::Parsers::OrderItem.new(node)
  end

  def test_asin
    assert_kind_of String, @order_item.asin
  end

  def test_order_item_id
    assert_kind_of String, @order_item.order_item_id
  end

  def test_seller_sku
    assert_kind_of String, @order_item.seller_sku
  end

  def test_title
    assert_kind_of String, @order_item.title
  end

  def test_quantity_ordered
    assert_kind_of Integer, @order_item.quantity_ordered
  end

  def test_quantity_shipped
    assert_kind_of Integer, @order_item.quantity_shipped
  end

  def test_item_price
    assert_kind_of Money, @order_item.item_price
  end

  def test_shipping_price
    assert_kind_of Money, @order_item.shipping_price
  end

  def test_scheduled_delivery_ends_at
    assert_kind_of Time, @order_item.scheduled_delivery_ends_at
  end

  def test_scheduled_delivery_starts_at
    assert_kind_of Time, @order_item.scheduled_delivery_starts_at
  end

  def test_cod_fee
    assert_kind_of Money, @order_item.cod_fee
  end

  def test_cod_fee_discount
    assert_kind_of Money, @order_item.cod_fee_discount
  end

  def test_gift_message_text
    assert_kind_of String, @order_item.gift_message_text
  end

  def test_gift_wrap_price
    assert_kind_of Money, @order_item.gift_wrap_price
  end

  def test_gift_wrap_level
    assert_kind_of String, @order_item.gift_wrap_level
  end
end
