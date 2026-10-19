# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20200701
      # An item that Amazon accepted for return.
      ReturnItem = Structure.new do
        # The identifier for the shipment that is associated with the return item.
        attribute(:amazon_shipment_id, String, null: false, from: "amazonShipmentId")

        # The identifier assigned to the item by the seller when the fulfillment order was created.
        attribute(:seller_fulfillment_order_item_id, String, null: false, from: "sellerFulfillmentOrderItemId")

        # An identifier the seller assigns to the return item.
        attribute(:seller_return_item_id, String, null: false, from: "sellerReturnItemId")

        # The return reason code assigned to the return item by the seller.
        attribute(:seller_return_reason_code, String, null: false, from: "sellerReturnReasonCode")

        # Indicates if the return item has been processed by an Amazon fulfillment center. Known values: `New`,
        # `Processed`.
        attribute(:status, String, null: false)

        # Indicates when the status last changed.
        attribute(:status_changed_date, String, null: false, from: "statusChangedDate")

        # The return reason code that the Amazon fulfillment center assigned to the return item.
        attribute?(:amazon_return_reason_code, String, from: "amazonReturnReasonCode")

        # The identifier for the Amazon fulfillment center that processed the return item.
        attribute?(:fulfillment_center_id, String, from: "fulfillmentCenterId")

        # Identifies the return authorization used to return this item. Refer to `ReturnAuthorization`.
        attribute?(:return_authorization_id, String, from: "returnAuthorizationId")

        # An optional comment about the return item.
        attribute?(:return_comment, String, from: "returnComment")

        # Known values: `Sellable`, `Defective`, `CustomerDamaged`, `CarrierDamaged`, `FulfillerDamaged`.
        attribute?(:return_received_condition, String, from: "returnReceivedCondition")
      end
    end
  end
end
