# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FulfillmentOrderStatus
      # Nested notification data
      FulfillmentOrderStatusNotification = Structure.new do
        # @return [String]
        attribute(:event_type, String, from: "EventType")

        # @return [String]
        attribute(:fulfillment_order_status, String, from: "FulfillmentOrderStatus")

        # @return [String]
        attribute(:seller_fulfillment_order_id, String, from: "SellerFulfillmentOrderId")

        # @return [String]
        attribute(:status_updated_date_time, String, from: "StatusUpdatedDateTime")

        # @return [FulfillmentReturnItem]
        attribute?(:fulfillment_return_item, FulfillmentReturnItem, from: "FulfillmentReturnItem")

        # @return [FulfillmentShipment]
        attribute?(:fulfillment_shipment, FulfillmentShipment, from: "FulfillmentShipment")

        # @return [String]
        attribute?(:seller_id, String, from: "SellerId")
      end
    end
  end
end
