# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ProductPricingV0
      # Information that identifies an item.
      ItemIdentifier = Structure.new do
        # @return [String] A marketplace identifier. Specifies the marketplace from which prices are returned.
        attribute(:marketplace_id, String, from: "MarketplaceId")

        # @return [String] The Amazon Standard Identification Number (ASIN) of the item.
        attribute(:asin, String, from: "ASIN")

        # @return [String] The seller stock keeping unit (SKU) of the item.
        attribute(:seller_sku, String, from: "SellerSKU")

        # @return [String] The condition of the item.
        attribute(:item_condition, String, from: "ItemCondition")
      end
    end
  end
end
