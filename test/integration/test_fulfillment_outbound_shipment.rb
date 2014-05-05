require 'integration_helper'
require 'mws/fulfillment_outbound_shipment'
require 'excon/errors'

class FulfillmentOutboundShipmentTest < IntegrationTest
  TEST_VER = 4
  
  def test_gets_service_status
    clients.each do |client|
      res = client.get_service_status
      refute_empty res.parse
    end
  end
  
  def test_create_fulfillment_order
    begin 
      clients.each do |client|
        sellerFulfillmentOrderId = "frobnitz-#{TEST_VER}"
        displayableOrderId = "Schnizzlebits-#{TEST_VER}"
        displayableOrderDateTime = "2014-04-15T08:18:44+00:00"
        displayableOrderComment = "Thanks for your fantastic order"
        shippingSpeedCategory = "Standard"
      
        address = {
          :name => "Snoop Dog",
          :line1 => "4339 H Dr.",
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
      
        res = client.create_fulfillment_order(sellerFulfillmentOrderId, displayableOrderId, displayableOrderDateTime,
                                              displayableOrderComment, shippingSpeedCategory, address, [item])
        
        # Note: sometimes this test fails because you can't cancel an order immediately after 
        # creating it.  MWS will return an internal server error like "SIRM call failed"
        # If this happens, comment out the create_fulfillment_order call and try running the test again
        # after a minute or two, and it should pass.  Once you have all the VCR cassettes you should be fine                                    
        client.cancel_fulfillment_order(sellerFulfillmentOrderId)
      end
    
    rescue Excon::Errors::HTTPStatusError => e
      warn "Failure (status: #{e.response.status}): #{e.response.body}"
      raise e 
    end
  end
end
