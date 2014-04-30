require 'integration_helper'
require 'mws/fulfillment_outbound_shipment'

class FulfillmentOutboundShipmentTest < IntegrationTest
  TEST_VER = 2
  
  def test_gets_service_status
    clients.each do |client|
      res = client.get_service_status
      refute_empty res.parse
    end
  end
  
  def test_create_fulfillment_order
    clients.each do |client|
      orderOpts = {
        :seller_fulfillment_order_id => "frobnitz-#{TEST_VER}",
        :fulfillment_action => 'Hold',
        :displayable_order_id => "Schnizzlebits-#{TEST_VER}",
        :displayable_order_date_time => "2014-04-15T08:18:44+00:00",
        :displayable_order_comment => "Thanks for your fantastic order",
        :shipping_speed_category => "Standard",
      }
      
      address = {
        :name => "Blake Scholl",
        :line1 => "4339 Harbord Dr.",
        :city => "Oakland",
        :state_or_province_code => "CA",
        :country_code => "US",
        :postal_code => "94618"
      }
      
      item = {
        'SellerSKU' => 'PI-ANX1-KMPO',
        :seller_fulfillment_order_item_id => "orderfrobnitz-#{TEST_VER}",
        :quantity => 1
      }
      
      res = client.create_fulfillment_order(orderOpts, address, [item])
      client.cancel_fulfillment_order(orderOpts[:seller_fulfillment_order_id])
    end
  end
end
