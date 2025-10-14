# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # The standard product comparison table.
      StandardComparisonTableModule = Structure.new do
        # @return [Array<PlainTextItem>]
        attribute?(:metric_row_labels, [PlainTextItem], from: "metricRowLabels")

        # @return [Array<StandardComparisonProductBlock>]
        attribute?(:product_columns, [StandardComparisonProductBlock], from: "productColumns")
      end
    end
  end
end
