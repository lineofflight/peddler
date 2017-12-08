# frozen_string_literal: true

require 'integration_helper'
require 'mws/orders'

class TestOrders < IntegrationTest
  def test_gets_orders
    clients.each do |client|
      order_ids = client.list_orders(created_after: Date.new(2015),
                                     max_results_per_page: 5)
                        .dig('Orders', 'Order')
                        .map { |order| order['AmazonOrderId'] }

      next if order_ids.count < 2

      orders = client.get_order(*order_ids)
                     .dig('Orders', 'Order')

      assert_equal order_ids.count, orders.count
    end
  end

  def test_gets_service_status
    clients.each do |client|
      res = client.get_service_status
      refute_empty res.parse
    end
  end
end
