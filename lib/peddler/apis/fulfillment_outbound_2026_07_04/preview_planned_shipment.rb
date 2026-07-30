# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # A group of items to be delivered together.
      PreviewPlannedShipment = Structure.new do
        # @return [Array<PreviewPlannedShipmentItem>] The items in this planned shipment. These can be a subset of
        #   lineItems from the request depending on how shipments are planned.
        attribute(:items, [PreviewPlannedShipmentItem], null: false)

        # @return [Weight] The estimated shipping weight of the planned shipment.
        attribute?(:estimated_shipping_weight, Weight, from: "estimatedShippingWeight")

        # @return [Array<PreviewDeliveryOffer>] An array of offers for this planned shipment.
        attribute?(:offers, [PreviewDeliveryOffer])
      end
    end
  end
end
