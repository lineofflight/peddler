# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/catalog_items_2022_04_01/dimensions"

module Peddler
  module Types
    module CatalogItems20220401
      # Dimensions that are associated with the item in the Amazon catalog for the indicated `marketplaceId`.
      ItemDimensionsByMarketplace = Structure.new do
        # @return [String] Amazon marketplace identifier. To find the ID for your marketplace, refer to [Marketplace
        # IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [Dimensions] Dimensions of an Amazon catalog item.
        attribute?(:item, Dimensions)

        # @return [Dimensions] Dimensions of a package that contains an Amazon catalog item.
        attribute?(:package, Dimensions)
      end
    end
  end
end
