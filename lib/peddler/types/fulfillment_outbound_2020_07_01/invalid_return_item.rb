# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_outbound_2020_07_01/invalid_item_reason"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # An item that is invalid for return.
      InvalidReturnItem = Structure.new do
        # @return [InvalidItemReason]
        attribute(:invalid_item_reason, InvalidItemReason, from: "invalidItemReason")

        # @return [String] The identifier assigned to the item by the seller when the fulfillment order was created.
        attribute(:seller_fulfillment_order_item_id, String, from: "sellerFulfillmentOrderItemId")

        # @return [String] An identifier the seller assigns to the return item.
        attribute(:seller_return_item_id, String, from: "sellerReturnItemId")
      end
    end
  end
end
