# frozen_string_literal: true

require "peddler/types/catalog_items_2020_12_01/item_image"

module Peddler
  module Types
    module CatalogItems20201201
      # Images for an item in the Amazon catalog for the indicated Amazon marketplace.
      ItemImagesByMarketplace = Structure.new do
        # @return [String] Amazon marketplace identifier.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [Array<ItemImage>] Images for an item in the Amazon catalog for the indicated Amazon marketplace.
        attribute(:images, [ItemImage])
      end
    end
  end
end
