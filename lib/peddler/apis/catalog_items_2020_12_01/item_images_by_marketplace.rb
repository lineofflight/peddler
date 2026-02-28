# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CatalogItems20201201
      # Images for an item in the Amazon catalog for the indicated Amazon marketplace.
      ItemImagesByMarketplace = Structure.new do
        # @return [Array<ItemImage>] Images for an item in the Amazon catalog for the indicated Amazon marketplace.
        attribute(:images, [ItemImage], null: false)

        # @return [String] Amazon marketplace identifier.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")
      end
    end
  end
end
