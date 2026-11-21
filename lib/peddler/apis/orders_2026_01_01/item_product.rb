# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Orders20260101
      # Product information for an order item.
      ItemProduct = Structure.new do
        # The Amazon Standard Identification Number (ASIN) of the item.
        attribute?(:asin, String)

        # Information about the physical condition and quality of the item being sold.
        attribute?(:condition, ItemCondition)

        # Information about any personalization or customization applied to this product.
        attribute?(:customization, ItemCustomization)

        # Pricing information for this product.
        attribute?(:price, ItemPrice)

        # The item's seller stock keeping unit (SKU).
        attribute?(:seller_sku, String, from: "sellerSku")

        # Unique serial numbers for products that require individual tracking, typically provided for FBA orders.
        attribute?(:serial_numbers, [String], from: "serialNumbers")

        # The product name or title as displayed to customers in the marketplace.
        attribute?(:title, String)
      end
    end
  end
end
