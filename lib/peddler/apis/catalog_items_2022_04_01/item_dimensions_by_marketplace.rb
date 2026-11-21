# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module CatalogItems20220401
      # Dimensions that are associated with the item in the Amazon catalog for the indicated `marketplaceId`.
      ItemDimensionsByMarketplace = Structure.new do
        # Amazon marketplace identifier. To find the ID for your marketplace, refer to [Marketplace
        # IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # Dimensions of an Amazon catalog item.
        attribute?(:item, Dimensions)

        # Dimensions of a package that contains an Amazon catalog item.
        attribute?(:package, Dimensions)
      end
    end
  end
end
