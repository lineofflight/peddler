require 'integration_helper'
require 'mws/fulfillment_inventory'

class FulfillmentInventoryTest < IntegrationTest
  def a_month_ago
    Date.today - 30
  end

  def test_lists_inventory_supply
    clients.each do |client|
      res = client.list_inventory_supply(query_start_date_time: a_month_ago)
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
