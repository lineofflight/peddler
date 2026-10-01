# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # Comparison row for table-based comparison modules.
      ComparisonRow = Structure.new do
        # @return [TextComponent]
        attribute?(:additional_info, TextComponent, from: "additionalInfo")

        # @return [Array<ComparisonFields>] Collection of comparison field values, one set per product.
        attribute?(:comparison_fields, [ComparisonFields], from: "comparisonFields")

        # @return [TextComponent]
        attribute?(:comparison_type, TextComponent, from: "comparisonType")

        # @return [TextComponent]
        attribute?(:metric_name, TextComponent, from: "metricName")

        # @return [Integer] The position of the comparison row.
        attribute?(:position, Integer)
      end
    end
  end
end
