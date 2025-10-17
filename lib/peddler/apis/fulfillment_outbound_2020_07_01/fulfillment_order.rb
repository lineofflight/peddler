# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # General information about a fulfillment order, including its status.
      FulfillmentOrder = Structure.new do
        # @return [Address] The destination address submitted with the `createFulfillmentOrder` operation.
        attribute(:destination_address, Address, from: "destinationAddress")

        # @return [String] A text block submitted with the `createFulfillmentOrder` operation. Displays in
        #   recipient-facing materials such as the packing slip.
        attribute(:displayable_order_comment, String, from: "displayableOrderComment")

        # @return [String] A date and time submitted with the `createFulfillmentOrder` operation. Displays as the order
        #   date in recipient-facing materials such as the packing slip.
        attribute(:displayable_order_date, String, from: "displayableOrderDate")

        # @return [String] A fulfillment order identifier submitted with the `createFulfillmentOrder` operation.
        #   Displays as the order identifier in recipient-facing materials such as the packing slip.
        attribute(:displayable_order_id, String, from: "displayableOrderId")

        # @return [String]
        attribute(:fulfillment_order_status, String, from: "fulfillmentOrderStatus")

        # @return [String] The identifier for the marketplace the fulfillment order is placed against.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String] The date and time that the fulfillment order was received by an Amazon fulfillment center.
        attribute(:received_date, String, from: "receivedDate")

        # @return [String] The fulfillment order identifier submitted with the `createFulfillmentOrder` operation.
        attribute(:seller_fulfillment_order_id, String, from: "sellerFulfillmentOrderId")

        # @return [String]
        attribute(:shipping_speed_category, String, from: "shippingSpeedCategory")

        # @return [String] The date and time that the status of the fulfillment order last changed. Must be in
        #   {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
        attribute(:status_updated_date, String, from: "statusUpdatedDate")

        # @return [CODSettings]
        attribute?(:cod_settings, CODSettings, from: "codSettings")

        # @return [DeliveryWindow]
        attribute?(:delivery_window, DeliveryWindow, from: "deliveryWindow")

        # @return [Array<FeatureSettings>] A list of features and their fulfillment policies to apply to the order.
        attribute?(:feature_constraints, [FeatureSettings], from: "featureConstraints")

        # @return [String]
        attribute?(:fulfillment_action, String, from: "fulfillmentAction")

        # @return [String]
        attribute?(:fulfillment_policy, String, from: "fulfillmentPolicy")

        # @return [Array<String>]
        attribute?(:notification_emails, [String], from: "notificationEmails")
      end
    end
  end
end
