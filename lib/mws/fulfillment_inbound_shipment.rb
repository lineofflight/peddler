require 'peddler/client'

module MWS
  # With the Fulfillment Inbound Shipment API, you can create and update inbound
  # shipments of inventory in the Amazon Fulfillment Network. You can also
  # also request lists of inbound shipments or inbound shipment items based on
  # criteria that you specify.
  #
  # @todo Not implemented
  class FulfillmentInboundShipment < ::Peddler::Client
    path 'FulfillmentInboundShipment/2010-10-01'
  end
end
