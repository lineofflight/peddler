# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ProductPricingV0
      # Schema to identify an item by MarketPlaceId, SellerId, and SellerSKU.
      SellerSKUIdentifier = Structure.new do
        # @return [String] A marketplace identifier.
        attribute(:marketplace_id, String, from: "MarketplaceId")

        # @return [String] The seller identifier submitted for the operation.
        attribute(:seller_id, String, from: "SellerId")

        # @return [String] The seller stock keeping unit (SKU) of the item.
        attribute(:seller_sku, String, from: "SellerSKU")
      end
    end
  end
end
