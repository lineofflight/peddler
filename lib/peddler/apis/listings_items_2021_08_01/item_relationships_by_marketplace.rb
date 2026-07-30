# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
      # Relationship details for the listing item in the specified Amazon store.
      ItemRelationshipsByMarketplace = Structure.new do
        # @return [String] Amazon store identifier.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [Array<ItemRelationship>] Relationships for the listing item.
        attribute(:relationships, [ItemRelationship], null: false)
      end
    end
  end
end
