# frozen_string_literal: true

require "peddler/types/listings_items_2021_08_01/item_relationship"

module Peddler
  module Types
    module ListingsItems20210801
      # Relationship details for the listing item in the specified marketplace.
      ItemRelationshipsByMarketplace = Structure.new do
        # @return [String] Amazon marketplace identifier.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [Array<ItemRelationship>] Relationships for the listing item.
        attribute(:relationships, [ItemRelationship])
      end
    end
  end
end
