# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # Information about unfulfillable items in a fulfillment order preview.
      UnfulfillablePreviewItem = Structure.new do
        # @return [Integer]
        attribute(:quantity, Integer)

        # @return [String] A fulfillment order item identifier created with a call to the `getFulfillmentPreview`
        #   operation.
        attribute(:seller_fulfillment_order_item_id, String, from: "sellerFulfillmentOrderItemId")

        # @return [String] The seller SKU of the item.
        attribute(:seller_sku, String, from: "sellerSku")

        # @return [Array<String>] Error codes associated with the fulfillment order preview that indicate why the item
        #   is unfulfillable.
        attribute?(:item_unfulfillable_reasons, [String], from: "itemUnfulfillableReasons")
      end
    end
  end
end
