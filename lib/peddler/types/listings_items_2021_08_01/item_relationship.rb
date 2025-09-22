# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/listings_items_2021_08_01/item_variation_theme"

module Peddler
  module Types
    module ListingsItems20210801
      # The relationship details for a listing item.
      ItemRelationship = Structure.new do
        # @return [Array<String>] Identifiers (SKUs) of the related items that are children of this listing item.
        attribute(:child_skus, [String], from: "childSkus")

        # @return [Array<String>] Identifiers (SKUs) of the related items that are parents of this listing item.
        attribute(:parent_skus, [String], from: "parentSkus")

        # @return [ItemVariationTheme] For `VARIATION` relationships, the variation theme is the combination of listing
        # item attributes that define the variation family.
        attribute(:variation_theme, ItemVariationTheme, from: "variationTheme")

        # @return [String] The type of relationship.
        attribute(:type, String)
      end
    end
  end
end
