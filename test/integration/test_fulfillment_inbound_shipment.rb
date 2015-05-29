require 'helper'
require 'mws/fulfillment_inbound_shipment'

class TestFulfillmentInboundShipment < IntegrationTest
  Address = Struct.new(:name, :address_line_1, :city, :state_or_province_code,
                       :postal_code, :country_code)
  Item = Struct.new(:seller_sku, :quantity)

  def test_creates_inbound_shipment_plan
    address = Address.new('John', '1 Main St', 'New York', 'NY', '10001', 'US')
    item = Item.new('123', 1)
    clients.each do |client|
      res = client.create_inbound_shipment_plan(address, [item])
      refute_empty res.parse
    end
  end

  def test_gets_service_status
    clients.each do |client|
      res = client.get_service_status
      refute_empty res.parse
    end
  end

  def test_handles_large_requests
    address = Address.new('John', '1 Main St', 'New York', 'NY', '10001', 'US')
    items = 100.times.map { |count| Item.new(count, 1) }
    clients.each do |client|
      res = client.create_inbound_shipment_plan(address, items)
      assert_equal 200, res.status
    end
  end
end
