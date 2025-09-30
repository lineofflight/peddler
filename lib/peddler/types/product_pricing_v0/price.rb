# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/product_pricing_v0/product"

module Peddler
  module Types
    module ProductPricingV0
      # Schema for price info in `getPricing` response
      Price = Structure.new do
        # @return [String] The status of the operation.
        attribute(:status, String)

        # @return [String] The seller stock keeping unit (SKU) of the item.
        attribute?(:seller_sku, String, from: "SellerSKU")

        # @return [String] The Amazon Standard Identification Number (ASIN) of the item.
        attribute?(:asin, String, from: "ASIN")

        # @return [Product]
        attribute?(:product, Product, from: "Product")
      end
    end
  end
end
