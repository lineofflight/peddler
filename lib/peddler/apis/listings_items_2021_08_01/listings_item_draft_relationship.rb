# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
      # Relationship details for a draft listings item.
      ListingsItemDraftRelationship = Structure.new do
        # @return [String] The type of relationship.
        attribute(:type, String, null: false)

        # @return [Array<ListingsItemDraftRelatedItem>] Child items in the relationship.
        attribute?(:children, [ListingsItemDraftRelatedItem])
      end
    end
  end
end
