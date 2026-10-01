# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A comparison row with metric values for each product.
      ThreeColumnComparisonRow = Structure.new do
        # @return [Array<MetricValueItem>] The metric values for each of the three products in this row. Exactly three
        #   items are required.
        attribute?(:metric_values, [MetricValueItem], from: "metricValues")

        # @return [Integer] Location of the row within the comparison table. Must be a value between 1 and 5.
        attribute?(:position, Integer)
      end
    end
  end
end
