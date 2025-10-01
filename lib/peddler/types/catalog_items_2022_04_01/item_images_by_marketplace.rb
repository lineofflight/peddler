# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/catalog_items_2022_04_01/item_image"

module Peddler
  module Types
    module CatalogItems20220401
      # Images for an item in the Amazon catalog, grouped by `marketplaceId`.
      ItemImagesByMarketplace = Structure.new do
        # @return [Array<ItemImage>] Images for an item in the Amazon catalog, grouped by `marketplaceId`.
        attribute(:images, [ItemImage])

        # @return [String] Amazon marketplace identifier. To find the ID for your marketplace, refer to [Marketplace
        # IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
        attribute(:marketplace_id, String, from: "marketplaceId")
      end
    end
  end
end
