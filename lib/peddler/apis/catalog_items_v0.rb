# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/api"

module Peddler
  class << self
    def catalog_items_v0
      typed? ? APIs::CatalogItemsV0.typed : APIs::CatalogItemsV0
    end
  end

  module APIs
    # Selling Partner API for Catalog Items
    #
    # The Selling Partner API for Catalog Items helps you programmatically retrieve item details for items in the
    # catalog.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/catalog-items-api-model/catalogItemsV0.json
    class CatalogItemsV0 < API
      class << self
        # Enables typed response parsing
        # @return [self]
        def typed
          @typed = true
          require_relative "../types/catalog_items_v0"
          self
        end
      end

      # Returns the parent categories to which an item belongs, based on the specified ASIN or SellerSKU.
      #
      # @note This operation can make a static sandbox call.
      # @param marketplace_id [String] A marketplace identifier. Specifies the marketplace for the item.
      # @param asin [String] The Amazon Standard Identification Number (ASIN) of the item.
      # @param seller_sku [String] Used to identify items in the given marketplace. SellerSKU is qualified by the
      #   seller's SellerId, which is included with every operation that you submit.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_catalog_categories(marketplace_id, asin: nil, seller_sku: nil, rate_limit: 1.0)
        path = "/catalog/v0/categories"
        params = {
          "MarketplaceId" => marketplace_id,
          "ASIN" => asin,
          "SellerSKU" => seller_sku,
        }.compact
        parser = Peddler::Types::CatalogItemsV0::ListCatalogCategoriesResponse if typed?
        meter(rate_limit).get(path, params:, parser:)
      end
    end
  end
end
