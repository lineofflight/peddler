# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/money"
require "structure"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # Item information for a fulfillment order preview.
      GetFulfillmentPreviewItem = Structure.new do
        # @return [Integer]
        attribute(:quantity, Integer)

        # @return [String] A fulfillment order item identifier that the seller creates to track items in the fulfillment
        # preview.
        attribute(:seller_fulfillment_order_item_id, String, from: "sellerFulfillmentOrderItemId")

        # @return [String] The seller SKU of the item.
        attribute(:seller_sku, String, from: "sellerSku")

        # @return [Money] The monetary value assigned by the seller to this item. This is a required field if this order
        # is an export order or an India MCF order.
        attribute?(:per_unit_declared_value, Money, from: "perUnitDeclaredValue")
      end
    end
  end
end
