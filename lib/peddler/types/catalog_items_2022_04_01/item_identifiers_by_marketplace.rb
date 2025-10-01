# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/catalog_items_2022_04_01/item_identifier"

module Peddler
  module Types
    module CatalogItems20220401
      # Identifiers that are associated with the item in the Amazon catalog, grouped by `marketplaceId`.
      ItemIdentifiersByMarketplace = Structure.new do
        # @return [Array<ItemIdentifier>] Identifiers associated with the item in the Amazon catalog for the indicated
        # `marketplaceId`.
        attribute(:identifiers, [ItemIdentifier])

        # @return [String] Amazon marketplace identifier. To find the ID for your marketplace, refer to [Marketplace
        # IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).identifier.
        attribute(:marketplace_id, String, from: "marketplaceId")
      end
    end
  end
end
