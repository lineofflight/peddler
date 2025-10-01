# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/catalog_items_2022_04_01/item_relationship"

module Peddler
  module Types
    module CatalogItems20220401
      # Relationship details for the Amazon catalog item for the specified Amazon `marketplaceId`.
      ItemRelationshipsByMarketplace = Structure.new do
        # @return [String] Amazon marketplace identifier. To find the ID for your marketplace, refer to [Marketplace
        # IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [Array<ItemRelationship>] Relationships for the item.
        attribute(:relationships, [ItemRelationship])
      end
    end
  end
end
