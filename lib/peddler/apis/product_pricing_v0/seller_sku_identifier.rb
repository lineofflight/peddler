# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricingV0
      # Schema to identify an item by MarketPlaceId, SellerId, and SellerSKU.
      SellerSKUIdentifier = Structure.new do
        # @return [String] A marketplace identifier.
        attribute(:marketplace_id, String, null: false, from: "MarketplaceId")

        # @return [String] The seller identifier submitted for the operation.
        attribute(:seller_id, String, null: false, from: "SellerId")

        # @return [String] The seller stock keeping unit (SKU) of the item.
        attribute(:seller_sku, String, null: false, from: "SellerSKU")
      end
    end
  end
end
