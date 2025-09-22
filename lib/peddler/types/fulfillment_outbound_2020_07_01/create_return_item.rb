# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # An item that Amazon accepted for return.
      CreateReturnItem = Structure.new do
        # @return [String] An identifier the seller assigns to the return item.
        attribute(:seller_return_item_id, String, from: "sellerReturnItemId")

        # @return [String] The identifier assigned to the item by the seller when the fulfillment order was created.
        attribute(:seller_fulfillment_order_item_id, String, from: "sellerFulfillmentOrderItemId")

        # @return [String] The identifier for the shipment that is associated with the return item.
        attribute(:amazon_shipment_id, String, from: "amazonShipmentId")

        # @return [String] The return reason code assigned to the return item by the seller.
        attribute(:return_reason_code, String, from: "returnReasonCode")

        # @return [String] An optional comment about the return item.
        attribute(:return_comment, String, from: "returnComment")
      end
    end
  end
end
