# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # The request body schema for the `getFulfillmentPreview` operation.
      GetFulfillmentPreviewRequest = Structure.new do
        # @return [Address] The destination address for the fulfillment order preview.
        attribute(:address, Address)

        # @return [Array<GetFulfillmentPreviewItem>] Identifying information and quantity information for the items in
        #   the fulfillment order preview. Maximum of 100 line items with a maximum of 250 units per order.
        attribute(:items, [GetFulfillmentPreviewItem])

        # @return [Array<FeatureSettings>] A list of features and their fulfillment policies to apply to the order.
        attribute?(:feature_constraints, [FeatureSettings], from: "featureConstraints")

        # @return [:boolean] When true, returns all fulfillment order previews both for COD and not for COD. Otherwise,
        #   returns only fulfillment order previews that are not for COD.
        attribute?(:include_cod_fulfillment_preview, :boolean, from: "includeCODFulfillmentPreview")

        # @return [:boolean] When true, returns the `ScheduledDeliveryInfo` response object, which contains the
        #   available delivery windows for a Scheduled Delivery. The `ScheduledDeliveryInfo` response object can only be
        #   returned for fulfillment order previews with `ShippingSpeedCategories` equal to `ScheduledDelivery`.
        attribute?(:include_delivery_windows, :boolean, from: "includeDeliveryWindows")

        # @return [String] The marketplace the fulfillment order is placed against.
        attribute?(:marketplace_id, String, from: "marketplaceId")

        # @return [Array<ShippingSpeedCategory>] A list of shipping methods used for creating fulfillment order
        #   previews.
        #
        # Possible values:
        #
        # * `Standard`: Standard shipping method.
        # * `Expedited`: Expedited shipping method.
        # * `Priority`: Priority shipping method.
        # * `ScheduledDelivery`: Scheduled Delivery shipping method.
        #
        # **Note:** Shipping method service level agreements vary by marketplace. Sellers should see the Seller Central
        #   website in their marketplace for shipping method service level agreements and fulfillment fees.
        attribute?(:shipping_speed_categories, Array, from: "shippingSpeedCategories")
      end
    end
  end
end
