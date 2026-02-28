# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CatalogItems20220401
      # Relationship details for an Amazon catalog item.
      ItemRelationship = Structure.new do
        # @return [String] Type of relationship.
        attribute(:type, String, null: false)

        # @return [Array<String>] ASINs of the related items that are children of this item.
        attribute?(:child_asins, [String], from: "childAsins")

        # @return [Array<String>] ASINs of the related items that are parents of this item.
        attribute?(:parent_asins, [String], from: "parentAsins")

        # @return [ItemVariationTheme] For `VARIATION` relationships, the variation theme indicates the combination of
        #   Amazon catalog item attributes that define the variation family.
        attribute?(:variation_theme, ItemVariationTheme, from: "variationTheme")
      end
    end
  end
end
