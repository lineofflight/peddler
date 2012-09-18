require 'peddler/service'

module Peddler
  # The Fulfillment Outbound Shipment API is designed to help you integrate
  # Fulfillment by Amazon with any payment processing application or inventory
  # management system currently in use.
  class FulfillmentOutboundShipment < Service
    path 'FulfillmentOutboundShipment/2010-10-01'
  end
end
