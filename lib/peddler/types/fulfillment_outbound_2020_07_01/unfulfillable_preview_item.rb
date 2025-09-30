# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # Information about unfulfillable items in a fulfillment order preview.
      UnfulfillablePreviewItem = Structure.new do
        # @return [String] The seller SKU of the item.
        attribute(:seller_sku, String, from: "sellerSku")

        # @return [Integer]
        attribute(:quantity, Integer)

        # @return [String] A fulfillment order item identifier created with a call to the `getFulfillmentPreview`
        # operation.
        attribute(:seller_fulfillment_order_item_id, String, from: "sellerFulfillmentOrderItemId")

        # @return [Array<String>] Error codes associated with the fulfillment order preview that indicate why the item
        # is unfulfillable.
        attribute?(:item_unfulfillable_reasons, [String], from: "itemUnfulfillableReasons")
      end
    end
  end
end
