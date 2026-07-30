# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
      # Variation relationships for a draft listings item, grouped by Amazon store.
      ListingsItemDraftRelationshipsByMarketplace = Structure.new do
        # @return [String] Amazon store identifier.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [Array<ListingsItemDraftRelationship>] Relationships for the draft listings item.
        attribute(:relationships, [ListingsItemDraftRelationship], null: false)
      end
    end
  end
end
