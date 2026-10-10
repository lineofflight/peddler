# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20200701
      # The request body schema for the `updateFulfillmentOrder` operation.
      UpdateFulfillmentOrderRequest = Structure.new do
        # The destination address for the fulfillment order.
        attribute?(:destination_address, Address, from: "destinationAddress")

        # Order-specific text that appears in recipient-facing materials such as the outbound shipment packing slip.
        attribute?(:displayable_order_comment, String, from: "displayableOrderComment")

        # The date and time of the fulfillment order. Displays as the order date in recipient-facing materials such as
        # the outbound shipment packing slip.
        attribute?(:displayable_order_date, String, from: "displayableOrderDate")

        # A fulfillment order identifier that the seller creates. This value displays as the order identifier in
        # recipient-facing materials such as the outbound shipment packing slip. The value of `DisplayableOrderId`
        # should match the order identifier that the seller provides to the recipient. The seller can use the
        # `SellerFulfillmentOrderId` for this value or they can specify an alternate value if they want the recipient to
        # reference an alternate order identifier.
        attribute?(:displayable_order_id, String, from: "displayableOrderId")

        # A list of features and their fulfillment policies to apply to the order.
        attribute?(:feature_constraints, [FeatureSettings], from: "featureConstraints")

        attribute?(:fulfillment_action, String, from: "fulfillmentAction")

        attribute?(:fulfillment_policy, String, from: "fulfillmentPolicy")

        # A list of items to include in the fulfillment order preview, including quantity.
        attribute?(:items, [UpdateFulfillmentOrderItem])

        # The marketplace the fulfillment order is placed against.
        attribute?(:marketplace_id, String, from: "marketplaceId")

        attribute?(:notification_emails, [String], from: "notificationEmails")

        # The two-character country code for the country from which the fulfillment order ships. Must be in ISO 3166-1
        # alpha-2 format.
        attribute?(:ship_from_country_code, String, from: "shipFromCountryCode")

        attribute?(:shipping_speed_category, String, from: "shippingSpeedCategory")
      end
    end
  end
end
