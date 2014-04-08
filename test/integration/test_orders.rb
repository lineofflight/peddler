require 'integration_helper'
require 'mws/orders'

class OrdersTest < IntegrationTest
  def a_year_ago
    Date.today - 365
  end

  def test_lists_orders
    clients.each do |client|
      res = client.list_orders(created_after: a_year_ago)
      refute_empty res.parse
    end
  end

  def test_gets_service_status
    clients.each do |client|
      res = client.get_service_status
      refute_empty res.parse
    end
  end
end
