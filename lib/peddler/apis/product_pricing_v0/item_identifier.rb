# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricingV0
      # Information that identifies an item.
      ItemIdentifier = Structure.new do
        # The condition of the item.
        attribute(:item_condition, String, null: false, from: "ItemCondition")

        # A marketplace identifier. Specifies the marketplace from which prices are returned.
        attribute(:marketplace_id, String, null: false, from: "MarketplaceId")

        # The Amazon Standard Identification Number (ASIN) of the item.
        attribute?(:asin, String, from: "ASIN")

        # The seller stock keeping unit (SKU) of the item.
        attribute?(:seller_sku, String, from: "SellerSKU")
      end
    end
  end
end
