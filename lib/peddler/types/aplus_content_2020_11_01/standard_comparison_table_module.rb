# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/aplus_content_2020_11_01/plain_text_item"
require "peddler/types/aplus_content_2020_11_01/standard_comparison_product_block"

module Peddler
  module Types
    module AplusContent20201101
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
