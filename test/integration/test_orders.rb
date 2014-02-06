require 'integration_helper'
require 'mws/orders'

class OrderItemsTest < IntegrationTest
  self.api = MWS::Orders

  def test_lists_and_gets_orders_and_order_items
    VCR.use_cassette('orders/lists_and_gets_orders_and_order_items') do
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

        order_items = client.list_order_items(amazon_order_ids.first)
        refute_empty order_items
      end
    end
  end

  def test_gets_service_status
    VCR.use_cassette('orders/gets_service_status') do
      @clients.each do |client|
        assert client.get_service_status
      end
    end
  end
end
