# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20200701
      # An item that is invalid for return.
      InvalidReturnItem = Structure.new do
        attribute(:invalid_item_reason, InvalidItemReason, null: false, from: "invalidItemReason")

        # The identifier assigned to the item by the seller when the fulfillment order was created.
        attribute(:seller_fulfillment_order_item_id, String, null: false, from: "sellerFulfillmentOrderItemId")

        # An identifier the seller assigns to the return item.
        attribute(:seller_return_item_id, String, null: false, from: "sellerReturnItemId")
      end
    end
  end
end
