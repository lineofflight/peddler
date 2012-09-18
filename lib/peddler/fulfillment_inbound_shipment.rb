require 'peddler/service'

# With the Fulfillment Inbound Shipment API, you can create and update inbound
# shipments of inventory in the Amazon Fulfillment Network. You can also
# request lists of inbound shipments or inbound shipment items based on
# criteria that you specify.
module Peddler
  class FulfillmentInboundShipment < Service
    path 'FulfillmentInboundShipment/2010-10-01'
  end
end
