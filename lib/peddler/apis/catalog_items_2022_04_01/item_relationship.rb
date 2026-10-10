# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module CatalogItems20220401
      # Relationship details for an Amazon catalog item.
      ItemRelationship = Structure.new do
        # Type of relationship.
        attribute(:type, String, null: false)

        # ASINs of the related items that are children of this item.
        attribute?(:child_asins, [String], from: "childAsins")

        # ASINs of the related items that are parents of this item.
        attribute?(:parent_asins, [String], from: "parentAsins")

        # For `VARIATION` relationships, the variation theme indicates the combination of Amazon catalog item attributes
        # that define the variation family.
        attribute?(:variation_theme, ItemVariationTheme, from: "variationTheme")
      end
    end
  end
end
