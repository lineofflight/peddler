# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A structured list of specification-definition pairs with a headline, for presenting key technical details of
      # your product.
      PremiumTechSpecsModule = Structure.new do
        # @return [TextComponent]
        attribute(:headline, TextComponent, null: false)

        # @return [Array<TechSpecs>] The collection of technical specifications, which must contain between 4 and 16
        #   technical specifications.
        attribute(:tech_specs, [TechSpecs], null: false, from: "techSpecs")

        # @return [Integer] The number of columns to display in the technical specifications table, with options between
        #   1 and 2 columns.
        attribute?(:column_count, Integer, from: "columnCount")
      end
    end
  end
end
