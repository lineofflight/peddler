require 'request_helper'
require 'mws/orders/requests/orders'

class MWSOrdersOrdersRequestTest < RequestTest
  def mock_response_body
    <<-EOF
      <Response xmlns="ns">
        <Result>
          <NextToken>123</NextToken>
          <Orders>
            <Order>
              <Id>123</Id>
            </Order>
          </Orders>
        </Result>
      </Response>
    EOF
  end

  def setup
    @orders = MWS::Orders::Requests::Orders.new(mock_client)
  end

  def test_lists_orders
    res = @orders.list(created_after: 0)
    assert_kind_of MWS::Orders::Parsers::Orders, res
  end

  def test_lists_orders_by_next_token
    mock_parsed_response = MiniTest::Mock.new
    mock_parsed_response.expect(:next_token, '123')
    @orders.last_parsed_response = mock_parsed_response
    res = @orders.list_by_next_token
    assert_kind_of MWS::Orders::Parsers::Orders, res
  end

  def test_gets_order
    res = @orders.get('123')
    assert_kind_of MWS::Orders::Parsers::Orders, res
  end

  def test_gets_multiple_orders
    res = @orders.get('123', '321')
    assert_kind_of MWS::Orders::Parsers::Orders, res
  end
end
