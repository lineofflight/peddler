# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
      # The relationship details for a listing item.
      ItemRelationship = Structure.new do
        # @return [String] The type of relationship.
        attribute(:type, String)

        # @return [Array<String>] Identifiers (SKUs) of the related items that are children of this listing item.
        attribute?(:child_skus, [String], from: "childSkus")

        # @return [Array<String>] Identifiers (SKUs) of the related items that are parents of this listing item.
        attribute?(:parent_skus, [String], from: "parentSkus")

        # @return [ItemVariationTheme] For `VARIATION` relationships, the variation theme is the combination of listing
        #   item attributes that define the variation family.
        attribute?(:variation_theme, ItemVariationTheme, from: "variationTheme")
      end
    end
  end
end
