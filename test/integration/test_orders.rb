# frozen_string_literal: true

require 'integration_helper'
require 'mws/orders'

class TestOrders < IntegrationTest
  def test_getting_orders
    clients.each do |client|
      orders = client.list_orders(client.marketplace.id,
                                  created_after: Date.new(2015),
                                  max_results_per_page: 5)
                     .dig('Orders', 'Order')
      next unless orders

      order_ids = orders.map { |order| order['AmazonOrderId'] }
      next if order_ids.count < 2

      res = client.get_order(*order_ids)
      orders = res.dig('Orders', 'Order')
      next if order_ids.any? { |id| id == 'FILTERED' }

      assert_equal order_ids.count, orders.count
    end
  end

  def test_getting_service_status
    clients.each do |client|
      res = client.get_service_status
      refute_empty res.parse
    end
  end
end
