# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CatalogItems20220401
      # Relationship details for the Amazon catalog item for the specified Amazon `marketplaceId`.
      ItemRelationshipsByMarketplace = Structure.new do
        # @return [String] Amazon marketplace identifier. To find the ID for your marketplace, refer to [Marketplace
        #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [Array<ItemRelationship>] Relationships for the item.
        attribute(:relationships, [ItemRelationship])
      end
    end
  end
end
