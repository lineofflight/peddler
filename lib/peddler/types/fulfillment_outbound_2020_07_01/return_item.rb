# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # An item that Amazon accepted for return.
      ReturnItem = Structure.new do
        # @return [String] An identifier the seller assigns to the return item.
        attribute(:seller_return_item_id, String, from: "sellerReturnItemId")

        # @return [String] The identifier assigned to the item by the seller when the fulfillment order was created.
        attribute(:seller_fulfillment_order_item_id, String, from: "sellerFulfillmentOrderItemId")

        # @return [String] The identifier for the shipment that is associated with the return item.
        attribute(:amazon_shipment_id, String, from: "amazonShipmentId")

        # @return [String] The return reason code assigned to the return item by the seller.
        attribute(:seller_return_reason_code, String, from: "sellerReturnReasonCode")

        # @return [String] An optional comment about the return item.
        attribute?(:return_comment, String, from: "returnComment")

        # @return [String] The return reason code that the Amazon fulfillment center assigned to the return item.
        attribute?(:amazon_return_reason_code, String, from: "amazonReturnReasonCode")

        # @return [String] Indicates if the return item has been processed by an Amazon fulfillment center.
        attribute(:status, String)

        # @return [String] Indicates when the status last changed.
        attribute(:status_changed_date, String, from: "statusChangedDate")

        # @return [String] Identifies the return authorization used to return this item. Refer to `ReturnAuthorization`.
        attribute?(:return_authorization_id, String, from: "returnAuthorizationId")

        # @return [String]
        attribute?(:return_received_condition, String, from: "returnReceivedCondition")

        # @return [String] The identifier for the Amazon fulfillment center that processed the return item.
        attribute?(:fulfillment_center_id, String, from: "fulfillmentCenterId")
      end
    end
  end
end
