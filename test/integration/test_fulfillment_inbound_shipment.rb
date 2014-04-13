require 'integration_helper'
require 'mws/fulfillment_inbound_shipment'

class FulfillmentInboundShipmentTest < IntegrationTest
  def test_gets_service_status
    clients.each do |client|
      res = client.get_service_status
      refute_empty res.parse
    end
  end
end
