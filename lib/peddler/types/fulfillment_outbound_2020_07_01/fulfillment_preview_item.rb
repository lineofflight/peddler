# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_outbound_2020_07_01/weight"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # Item information for a shipment in a fulfillment order preview.
      FulfillmentPreviewItem = Structure.new do
        # @return [Integer] The item quantity.
        attribute(:quantity, Integer)

        # @return [String] A fulfillment order item identifier that the seller created with a call to the
        # `createFulfillmentOrder` operation.
        attribute(:seller_fulfillment_order_item_id, String, from: "sellerFulfillmentOrderItemId")

        # @return [String] The seller SKU of the item.
        attribute(:seller_sku, String, from: "sellerSku")

        # @return [Weight] The estimated shipping weight of the item quantity for a single item, as identified by
        # `sellerSku`, in a shipment.
        attribute?(:estimated_shipping_weight, Weight, from: "estimatedShippingWeight")

        # @return [String] The method used to calculate the estimated shipping weight.
        attribute?(:shipping_weight_calculation_method, String, from: "shippingWeightCalculationMethod")
      end
    end
  end
end
