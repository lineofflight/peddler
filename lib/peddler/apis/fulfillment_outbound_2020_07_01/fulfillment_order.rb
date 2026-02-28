# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # General information about a fulfillment order, including its status.
      FulfillmentOrder = Structure.new do
        # @return [Address] The destination address submitted with the `createFulfillmentOrder` operation.
        attribute(:destination_address, Address, null: false, from: "destinationAddress")

        # @return [String] A text block submitted with the `createFulfillmentOrder` operation. Displays in
        #   recipient-facing materials such as the packing slip.
        attribute(:displayable_order_comment, String, null: false, from: "displayableOrderComment")

        # @return [String] A date and time submitted with the `createFulfillmentOrder` operation. Displays as the order
        #   date in recipient-facing materials such as the packing slip.
        attribute(:displayable_order_date, String, null: false, from: "displayableOrderDate")

        # @return [String] A fulfillment order identifier submitted with the `createFulfillmentOrder` operation.
        #   Displays as the order identifier in recipient-facing materials such as the packing slip.
        attribute(:displayable_order_id, String, null: false, from: "displayableOrderId")

        # @return [String]
        attribute(:fulfillment_order_status, String, null: false, from: "fulfillmentOrderStatus")

        # @return [String] The identifier for the marketplace the fulfillment order is placed against.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [String] The date and time that the fulfillment order was received by an Amazon fulfillment center.
        attribute(:received_date, String, null: false, from: "receivedDate")

        # @return [String] The fulfillment order identifier submitted with the `createFulfillmentOrder` operation.
        attribute(:seller_fulfillment_order_id, String, null: false, from: "sellerFulfillmentOrderId")

        # @return [String]
        attribute(:shipping_speed_category, String, null: false, from: "shippingSpeedCategory")

        # @return [String] The date and time that the status of the fulfillment order last changed. Must be in
        #   {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
        attribute(:status_updated_date, String, null: false, from: "statusUpdatedDate")

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
