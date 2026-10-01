# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A wrapper object for a single comparison row.
      ComparisonMetrics = Structure.new do
        # @return [ComparisonRow]
        attribute(:comparison_row, ComparisonRow, null: false, from: "comparisonRow")
      end
    end
  end
end
