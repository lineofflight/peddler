require 'request_helper'
require 'mws/orders/requests/order_items'

class MWSOrdersOrderItemsRequestTest < RequestTest
  def mock_response_body
    <<-EOF
      <Response xmlns="ns">
        <NextToken>123</NextToken>
        <OrderItems>
          <OrderItem>
            <Id>123</Id>
          </OrderItem>
        </OrderItems>
      </Response>
    EOF
  end

  def setup
    @order_items = MWS::Orders::Requests::OrderItems.new(mock_client)
  end

  def test_lists_order_items
    res = @order_items.list('123-1234567-1234567')
    assert_kind_of MWS::Orders::Parsers::OrderItems, res
  end

  def test_returns_next_token
    @order_items.last_response = mock_response
    assert_equal '123', @order_items.next_token
  end

  def test_lists_order_items_by_next_token
    @order_items.last_response = mock_response
    res = @order_items.list_by_next_token
    assert_kind_of MWS::Orders::Parsers::OrderItems, res
  end
end
