# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # The standard table of technical feature names and definitions.
      StandardTechSpecsModule = Structure.new do
        # @return [Array<StandardTextPairBlock>] The specification list.
        attribute(:specification_list, [StandardTextPairBlock], from: "specificationList")

        # @return [TextComponent]
        attribute?(:headline, TextComponent)

        # @return [Integer] The number of tables you want present. Features are evenly divided between the tables.
        attribute?(:table_count, Integer, from: "tableCount")
      end
    end
  end
end
