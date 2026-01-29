# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Product information for an order item.
      ItemProduct = Structure.new do
        # @return [String] The Amazon Standard Identification Number (ASIN) of the item.
        attribute?(:asin, String)

        # @return [ItemCondition] Information about the physical condition and quality of the item being sold.
        attribute?(:condition, ItemCondition)

        # @return [ItemCustomization] Information about any personalization or customization applied to this product.
        attribute?(:customization, ItemCustomization)

        # @return [ItemPrice] Pricing information for this product.
        attribute?(:price, ItemPrice)

        # @return [String] The item's seller stock keeping unit (SKU).
        attribute?(:seller_sku, String, from: "sellerSku")

        # @return [Array<String>] Unique serial numbers for products that require individual tracking, typically
        #   provided for FBA orders.
        attribute?(:serial_numbers, [String], from: "serialNumbers")

        # @return [String] The product name or title as displayed to customers in the marketplace.
        attribute?(:title, String)
      end
    end
  end
end
