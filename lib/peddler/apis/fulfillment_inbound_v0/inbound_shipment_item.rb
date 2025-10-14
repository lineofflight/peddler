# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInboundV0
      # Item information for an inbound shipment. Submitted with a call to the createInboundShipment or
      # updateInboundShipment operation.
      InboundShipmentItem = Structure.new do
        # @return [Integer] The item quantity that you are shipping.
        attribute(:quantity_shipped, Integer, from: "QuantityShipped")

        # @return [String] The seller SKU of the item.
        attribute(:seller_sku, String, from: "SellerSKU")

        # @return [String] Amazon's fulfillment network SKU of the item.
        attribute?(:fulfillment_network_sku, String, from: "FulfillmentNetworkSKU")

        # @return [Array<PrepDetails>]
        attribute?(:prep_details_list, [PrepDetails], from: "PrepDetailsList")

        # @return [Integer] The item quantity in each case, for case-packed items. Note that QuantityInCase multiplied
        # by the number of boxes in the inbound shipment equals QuantityShipped. Also note that all of the boxes of an
        # inbound shipment must either be case packed or individually packed. For that reason, when you submit the
        # createInboundShipment or the updateInboundShipment operation, the value of QuantityInCase must be provided for
        # every item in the shipment or for none of the items in the shipment.
        attribute?(:quantity_in_case, Integer, from: "QuantityInCase")

        # @return [Integer] The item quantity that has been received at an Amazon fulfillment center.
        attribute?(:quantity_received, Integer, from: "QuantityReceived")

        # @return [String] The date that a pre-order item will be available for sale.
        attribute?(:release_date, String, from: "ReleaseDate")

        # @return [String] A shipment identifier originally returned by the createInboundShipmentPlan operation.
        attribute?(:shipment_id, String, from: "ShipmentId")
      end
    end
  end
end
