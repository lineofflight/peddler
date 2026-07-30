# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
      # The request body schema for the `putListingsItemDraft` operation.
      ListingsItemDraftPutRequest = Structure.new do
        # @return [Hash] JSON object containing structured listings item attribute data keyed by attribute name.
        attribute(:attributes, Hash, null: false)

        # @return [String] The Amazon product type of the draft listings item.
        attribute(:product_type, String, null: false, from: "productType")

        # @return [Array<ListingsItemDraftRelationshipsByMarketplace>] Variation relationships for the draft listings
        #   item.
        attribute?(:relationships, [ListingsItemDraftRelationshipsByMarketplace])
      end
    end
  end
end
