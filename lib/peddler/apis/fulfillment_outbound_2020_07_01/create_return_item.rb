# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20200701
      # An item that Amazon accepted for return.
      CreateReturnItem = Structure.new do
        # The identifier for the shipment that is associated with the return item.
        attribute(:amazon_shipment_id, String, null: false, from: "amazonShipmentId")

        # The return reason code assigned to the return item by the seller.
        attribute(:return_reason_code, String, null: false, from: "returnReasonCode")

        # The identifier assigned to the item by the seller when the fulfillment order was created.
        attribute(:seller_fulfillment_order_item_id, String, null: false, from: "sellerFulfillmentOrderItemId")

        # An identifier the seller assigns to the return item.
        attribute(:seller_return_item_id, String, null: false, from: "sellerReturnItemId")

        # An optional comment about the return item.
        attribute?(:return_comment, String, from: "returnComment")
      end
    end
  end
end
