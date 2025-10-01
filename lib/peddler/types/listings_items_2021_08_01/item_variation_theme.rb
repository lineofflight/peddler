# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ListingsItems20210801
      # A variation theme that indicates the combination of listing item attributes that define the variation family.
      ItemVariationTheme = Structure.new do
        # @return [Array<String>] The names of the listing item attributes that are associated with the variation theme.
        attribute(:attributes, [String])

        # @return [String] The variation theme that indicates the combination of listing item attributes that define the
        # variation family.
        attribute(:theme, String)
      end
    end
  end
end
