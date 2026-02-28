# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CatalogItems20220401
      # Images for an item in the Amazon catalog, grouped by `marketplaceId`.
      ItemImagesByMarketplace = Structure.new do
        # @return [Array<ItemImage>] Images for an item in the Amazon catalog, grouped by `marketplaceId`.
        attribute(:images, [ItemImage], null: false)

        # @return [String] Amazon marketplace identifier. To find the ID for your marketplace, refer to [Marketplace
        #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")
      end
    end
  end
end
