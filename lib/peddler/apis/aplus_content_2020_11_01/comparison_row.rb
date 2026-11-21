# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # Comparison row for table-based comparison modules.
      ComparisonRow = Structure.new do
        attribute?(:additional_info, TextComponent, from: "additionalInfo")

        # Collection of comparison field values, one set per product.
        attribute?(:comparison_fields, [ComparisonFields], from: "comparisonFields")

        attribute?(:comparison_type, TextComponent, from: "comparisonType")

        attribute?(:metric_name, TextComponent, from: "metricName")

        # The position of the comparison row.
        attribute?(:position, Integer)
      end
    end
  end
end
