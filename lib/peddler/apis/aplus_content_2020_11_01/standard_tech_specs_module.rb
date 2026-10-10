# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # The standard table of technical feature names and definitions.
      StandardTechSpecsModule = Structure.new do
        # The specification list.
        attribute(:specification_list, [StandardTextPairBlock], null: false, from: "specificationList")

        attribute?(:headline, TextComponent)

        # The number of tables to present. Features are evenly divided between the tables.
        attribute?(:table_count, Integer, from: "tableCount")
      end
    end
  end
end
