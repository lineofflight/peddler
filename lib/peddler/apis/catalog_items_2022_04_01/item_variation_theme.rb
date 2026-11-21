# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module CatalogItems20220401
      # The variation theme is a list of Amazon catalog item attributes that define the variation family.
      ItemVariationTheme = Structure.new do
        # Names of the Amazon catalog item attributes that are associated with the variation theme.
        attribute?(:attributes, [String])

        # Variation theme that indicates the combination of Amazon catalog item attributes that define the variation
        # family.
        attribute?(:theme, String)
      end
    end
  end
end
