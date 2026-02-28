# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricingV0
      # Information that identifies an item.
      ItemIdentifier = Structure.new do
        # @return [String] The condition of the item.
        attribute(:item_condition, String, null: false, from: "ItemCondition")

        # @return [String] A marketplace identifier. Specifies the marketplace from which prices are returned.
        attribute(:marketplace_id, String, null: false, from: "MarketplaceId")

        # @return [String] The Amazon Standard Identification Number (ASIN) of the item.
        attribute?(:asin, String, from: "ASIN")

        # @return [String] The seller stock keeping unit (SKU) of the item.
        attribute?(:seller_sku, String, from: "SellerSKU")
      end
    end
  end
end
