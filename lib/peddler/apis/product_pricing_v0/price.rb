# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricingV0
      # Schema for price info in `getPricing` response
      Price = Structure.new do
        # @return [String] The status of the operation.
        attribute(:status, String, null: false)

        # @return [String] The Amazon Standard Identification Number (ASIN) of the item.
        attribute?(:asin, String, from: "ASIN")

        # @return [Product]
        attribute?(:product, Product, from: "Product")

        # @return [String] The seller stock keeping unit (SKU) of the item.
        attribute?(:seller_sku, String, from: "SellerSKU")
      end
    end
  end
end
