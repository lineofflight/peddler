# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20200701
      # General information about a fulfillment order, including its status.
      FulfillmentOrder = Structure.new do
        # The destination address submitted with the `createFulfillmentOrder` operation.
        attribute(:destination_address, Address, null: false, from: "destinationAddress")

        # A text block submitted with the `createFulfillmentOrder` operation. Displays in recipient-facing materials
        # such as the packing slip.
        attribute(:displayable_order_comment, String, null: false, from: "displayableOrderComment")

        # A date and time submitted with the `createFulfillmentOrder` operation. Displays as the order date in
        # recipient-facing materials such as the packing slip.
        attribute(:displayable_order_date, String, null: false, from: "displayableOrderDate")

        # A fulfillment order identifier submitted with the `createFulfillmentOrder` operation. Displays as the order
        # identifier in recipient-facing materials such as the packing slip.
        attribute(:displayable_order_id, String, null: false, from: "displayableOrderId")

        # Known values: `New`, `Received`, `Planning`, `Processing`, `Cancelled`, `Complete`, `CompletePartialled`,
        # `Unfulfillable`, `Invalid`.
        attribute(:fulfillment_order_status, String, null: false, from: "fulfillmentOrderStatus")

        # The identifier for the marketplace the fulfillment order is placed against.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # The date and time that the fulfillment order was received by an Amazon fulfillment center.
        attribute(:received_date, String, null: false, from: "receivedDate")

        # The fulfillment order identifier submitted with the `createFulfillmentOrder` operation.
        attribute(:seller_fulfillment_order_id, String, null: false, from: "sellerFulfillmentOrderId")

        # Known values: `Standard`, `Expedited`, `Priority`, `ScheduledDelivery`.
        attribute(:shipping_speed_category, String, null: false, from: "shippingSpeedCategory")

        # The date and time that the status of the fulfillment order last changed, in ISO 8601 date time format.
        attribute(:status_updated_date, String, null: false, from: "statusUpdatedDate")

        attribute?(:cod_settings, CODSettings, from: "codSettings")

        attribute?(:delivery_window, DeliveryWindow, from: "deliveryWindow")

        # A list of features and their fulfillment policies to apply to the order.
        attribute?(:feature_constraints, [FeatureSettings], from: "featureConstraints")

        # Known values: `Ship`, `Hold`.
        attribute?(:fulfillment_action, String, from: "fulfillmentAction")

        # Known values: `FillOrKill`, `FillAll`, `FillAllAvailable`.
        attribute?(:fulfillment_policy, String, from: "fulfillmentPolicy")

        attribute?(:notification_emails, [String], from: "notificationEmails")
      end
    end
  end
end
