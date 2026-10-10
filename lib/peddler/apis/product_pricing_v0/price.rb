# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricingV0
      # Schema for price info in `getPricing` response
      Price = Structure.new do
        # The status of the operation.
        attribute(:status, String, null: false)

        # The Amazon Standard Identification Number (ASIN) of the item.
        attribute?(:asin, String, from: "ASIN")

        attribute?(:product, Product, from: "Product")

        # The seller stock keeping unit (SKU) of the item.
        attribute?(:seller_sku, String, from: "SellerSKU")
      end
    end
  end
end
