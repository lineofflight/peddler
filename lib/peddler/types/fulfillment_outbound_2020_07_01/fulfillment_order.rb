# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/delivery_window"
require "peddler/types/fulfillment_outbound_2020_07_01/address"
require "peddler/types/fulfillment_outbound_2020_07_01/cod_settings"
require "peddler/types/fulfillment_outbound_2020_07_01/feature_settings"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # General information about a fulfillment order, including its status.
      FulfillmentOrder = Structure.new do
        # @return [String] The fulfillment order identifier submitted with the `createFulfillmentOrder` operation.
        attribute(:seller_fulfillment_order_id, String, from: "sellerFulfillmentOrderId")

        # @return [String] The identifier for the marketplace the fulfillment order is placed against.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String] A fulfillment order identifier submitted with the `createFulfillmentOrder` operation.
        # Displays as the order identifier in recipient-facing materials such as the packing slip.
        attribute(:displayable_order_id, String, from: "displayableOrderId")

        # @return [String] A date and time submitted with the `createFulfillmentOrder` operation. Displays as the order
        # date in recipient-facing materials such as the packing slip.
        attribute(:displayable_order_date, String, from: "displayableOrderDate")

        # @return [String] A text block submitted with the `createFulfillmentOrder` operation. Displays in
        # recipient-facing materials such as the packing slip.
        attribute(:displayable_order_comment, String, from: "displayableOrderComment")

        # @return [String]
        attribute(:shipping_speed_category, String, from: "shippingSpeedCategory")

        # @return [DeliveryWindow]
        attribute(:delivery_window, DeliveryWindow, from: "deliveryWindow")

        # @return [Address] The destination address submitted with the `createFulfillmentOrder` operation.
        attribute(:destination_address, Address, from: "destinationAddress")

        # @return [String]
        attribute(:fulfillment_action, String, from: "fulfillmentAction")

        # @return [String]
        attribute(:fulfillment_policy, String, from: "fulfillmentPolicy")

        # @return [CODSettings]
        attribute(:cod_settings, CODSettings, from: "codSettings")

        # @return [String] The date and time that the fulfillment order was received by an Amazon fulfillment center.
        attribute(:received_date, String, from: "receivedDate")

        # @return [String]
        attribute(:fulfillment_order_status, String, from: "fulfillmentOrderStatus")

        # @return [String] The date and time that the status of the fulfillment order last changed. Must be in <a
        # href='https://developer-docs.amazon.com/sp-api/docs/iso-8601'>ISO 8601</a> format.
        attribute(:status_updated_date, String, from: "statusUpdatedDate")

        # @return [Array]
        attribute(:notification_emails, Array, from: "notificationEmails")

        # @return [Array<FeatureSettings>] A list of features and their fulfillment policies to apply to the order.
        attribute(:feature_constraints, [FeatureSettings], from: "featureConstraints")
      end
    end
  end
end
