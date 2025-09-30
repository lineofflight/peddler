# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/aplus_content_2020_11_01/standard_comparison_product_block"
require "peddler/types/aplus_content_2020_11_01/plain_text_item"

module Peddler
  module Types
    module AplusContent20201101
      # The standard product comparison table.
      StandardComparisonTableModule = Structure.new do
        # @return [Array<StandardComparisonProductBlock>]
        attribute?(:product_columns, [StandardComparisonProductBlock], from: "productColumns")

        # @return [Array<PlainTextItem>]
        attribute?(:metric_row_labels, [PlainTextItem], from: "metricRowLabels")
      end
    end
  end
end
