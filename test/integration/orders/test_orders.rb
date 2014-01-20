require 'integration_helper'
require 'mws/orders'

class OrdersTest < IntegrationTest
  self.api = MWS::Orders

  def test_lists_and_gets_orders
    VCR.use_cassette('orders_test/test_lists_and_gets_orders') do
      @clients.each do |client|
        amazon_order_ids = []
        orders = client.list_orders(created_after: Date.today - 365)
        amazon_order_ids << orders.to_a.first.amazon_order_id

        orders = client.list_orders_by_next_token
        amazon_order_ids << orders.to_a.first.amazon_order_id

        orders = client.list_orders_by_next_token(orders.next_token)
        amazon_order_ids << orders.to_a.first.amazon_order_id

        orders = client.get_order(*amazon_order_ids)
        assert orders
      end
    end
  end
end
