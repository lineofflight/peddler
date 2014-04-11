require 'peddler/client'

module MWS
  # The Fulfillment Outbound Shipment API enables you to fulfill orders placed
  # through channels other than Amazon's retail web site, using your inventory
  # in the Amazon Fulfillment Network. You can request previews of potential
  # fulfillment orders that return estimated shipping fees and shipping dates
  # based on shipping speed. You can get detailed item-level, shipment-level,
  # and order-level information for any existing fulfillment order that you
  # specify. You can also request lists of existing fulfillment orders based on
  # when they were fulfilled and by the fulfillment method associated with them.
  #
  # @todo Not implemented
  class FulfillmentOutboundShipment < ::Peddler::Client
    path '/FulfillmentOutboundShipment/2010-10-01'
  end
end
