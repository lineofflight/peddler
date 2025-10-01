# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/product_pricing_v0/asin_identifier"
require "peddler/types/product_pricing_v0/seller_sku_identifier"

module Peddler
  module Types
    module ProductPricingV0
      # Specifies the identifiers used to uniquely identify an item.
      IdentifierType = Structure.new do
        # @return [ASINIdentifier] Indicates the item is identified by MarketPlaceId and ASIN.
        attribute(:marketplace_asin, ASINIdentifier, from: "MarketplaceASIN")

        # @return [SellerSKUIdentifier] Indicates the item is identified by MarketPlaceId, SellerId, and SellerSKU.
        attribute?(:sku_identifier, SellerSKUIdentifier, from: "SKUIdentifier")
      end
    end
  end
end
