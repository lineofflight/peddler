# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # The request body schema for the `updateFulfillmentOrder` operation.
      UpdateFulfillmentOrderRequest = Structure.new do
        # @return [Address] The destination address for the fulfillment order.
        attribute?(:destination_address, Address, from: "destinationAddress")

        # @return [String] Order-specific text that appears in recipient-facing materials such as the outbound shipment
        #   packing slip.
        attribute?(:displayable_order_comment, String, from: "displayableOrderComment")

        # @return [String] The date and time of the fulfillment order. Displays as the order date in recipient-facing
        #   materials such as the outbound shipment packing slip.
        attribute?(:displayable_order_date, String, from: "displayableOrderDate")

        # @return [String] A fulfillment order identifier that the seller creates. This value displays as the order
        #   identifier in recipient-facing materials such as the outbound shipment packing slip. The value of
        #   `DisplayableOrderId` should match the order identifier that the seller provides to the recipient. The seller
        #   can use the `SellerFulfillmentOrderId` for this value or they can specify an alternate value if they want
        #   the recipient to reference an alternate order identifier.
        attribute?(:displayable_order_id, String, from: "displayableOrderId")

        # @return [Array<FeatureSettings>] A list of features and their fulfillment policies to apply to the order.
        attribute?(:feature_constraints, [FeatureSettings], from: "featureConstraints")

        # @return [String]
        attribute?(:fulfillment_action, String, from: "fulfillmentAction")

        # @return [String]
        attribute?(:fulfillment_policy, String, from: "fulfillmentPolicy")

        # @return [Array<UpdateFulfillmentOrderItem>] A list of items to include in the fulfillment order preview,
        #   including quantity.
        attribute?(:items, [UpdateFulfillmentOrderItem])

        # @return [String] The marketplace the fulfillment order is placed against.
        attribute?(:marketplace_id, String, from: "marketplaceId")

        # @return [Array<String>]
        attribute?(:notification_emails, [String], from: "notificationEmails")

        # @return [String] The two-character country code for the country from which the fulfillment order ships. Must
        #   be in ISO 3166-1 alpha-2 format.
        attribute?(:ship_from_country_code, String, from: "shipFromCountryCode")

        # @return [String]
        attribute?(:shipping_speed_category, String, from: "shippingSpeedCategory")
      end
    end
  end
end
