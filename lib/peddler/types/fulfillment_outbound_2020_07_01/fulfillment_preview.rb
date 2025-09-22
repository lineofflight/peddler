# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_outbound_2020_07_01/scheduled_delivery_info"
require "peddler/types/fulfillment_outbound_2020_07_01/weight"
require "peddler/types/fulfillment_outbound_2020_07_01/fee"
require "peddler/types/fulfillment_outbound_2020_07_01/fulfillment_preview_shipment"
require "peddler/types/fulfillment_outbound_2020_07_01/unfulfillable_preview_item"
require "peddler/types/fulfillment_outbound_2020_07_01/feature_settings"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # Information about a fulfillment order preview, including delivery and fee information based on shipping method.
      FulfillmentPreview = Structure.new do
        # @return [String]
        attribute(:shipping_speed_category, String, from: "shippingSpeedCategory")

        # @return [ScheduledDeliveryInfo]
        attribute(:scheduled_delivery_info, ScheduledDeliveryInfo, from: "scheduledDeliveryInfo")

        # @return [:boolean] When true, this fulfillment order preview is fulfillable.
        attribute(:fulfillable, :boolean, from: "isFulfillable")

        # @return [:boolean] When true, this fulfillment order preview is for COD (Cash On Delivery).
        attribute(:cod_capable, :boolean, from: "isCODCapable")

        # @return [Weight] Estimated shipping weight for this fulfillment order preview.
        attribute(:estimated_shipping_weight, Weight, from: "estimatedShippingWeight")

        # @return [Array<Fee>] The estimated fulfillment fees for this fulfillment order preview, if applicable. The
        # fees data will not be available for IN marketplace orders.
        attribute(:estimated_fees, [Fee], from: "estimatedFees")

        # @return [Array<FulfillmentPreviewShipment>]
        attribute(:fulfillment_preview_shipments, [FulfillmentPreviewShipment], from: "fulfillmentPreviewShipments")

        # @return [Array<UnfulfillablePreviewItem>]
        attribute(:unfulfillable_preview_items, [UnfulfillablePreviewItem], from: "unfulfillablePreviewItems")

        # @return [Array] Error codes associated with the fulfillment order preview that indicate why the order is not
        # fulfillable.
        #
        # Error code examples:
        #
        # `DeliverySLAUnavailable`
        # `InvalidDestinationAddress`
        attribute(:order_unfulfillable_reasons, Array, from: "orderUnfulfillableReasons")

        # @return [String] The marketplace the fulfillment order is placed against.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [Array<FeatureSettings>] A list of features and their fulfillment policies to apply to the order.
        attribute(:feature_constraints, [FeatureSettings], from: "featureConstraints")
      end
    end
  end
end
