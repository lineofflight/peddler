# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20200701
      # Information about a fulfillment order preview, including delivery and fee information based on shipping method.
      FulfillmentPreview = Structure.new do
        # When true, this fulfillment order preview is for COD (Cash On Delivery).
        attribute(:cod_capable, :boolean, null: false, from: "isCODCapable")

        # When true, this fulfillment order preview is fulfillable.
        attribute(:fulfillable, :boolean, null: false, from: "isFulfillable")

        # The marketplace the fulfillment order is placed against.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        attribute(:shipping_speed_category, String, null: false, from: "shippingSpeedCategory")

        # The estimated fulfillment fees for this fulfillment order preview, if applicable. The fees data will not be
        # available for IN marketplace orders.
        attribute?(:estimated_fees, [Fee], from: "estimatedFees")

        # Estimated shipping weight for this fulfillment order preview.
        attribute?(:estimated_shipping_weight, Weight, from: "estimatedShippingWeight")

        # A list of features and their fulfillment policies to apply to the order.
        attribute?(:feature_constraints, [FeatureSettings], from: "featureConstraints")

        attribute?(:fulfillment_preview_shipments, [FulfillmentPreviewShipment], from: "fulfillmentPreviewShipments")

        # Error codes associated with the fulfillment order preview that indicate why the order is not fulfillable.
        #
        # Error code examples:
        #
        # `DeliverySLAUnavailable` `InvalidDestinationAddress`
        attribute?(:order_unfulfillable_reasons, [String], from: "orderUnfulfillableReasons")

        attribute?(:scheduled_delivery_info, ScheduledDeliveryInfo, from: "scheduledDeliveryInfo")

        attribute?(:unfulfillable_preview_items, [UnfulfillablePreviewItem], from: "unfulfillablePreviewItems")
      end
    end
  end
end
