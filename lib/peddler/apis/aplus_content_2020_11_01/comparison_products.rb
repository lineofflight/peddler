# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A wrapper object for a single comparison product.
      ComparisonProducts = Structure.new do
        # @return [ComparisonProduct]
        attribute(:comparison_product, ComparisonProduct, null: false, from: "comparisonProduct")
      end
    end
  end
end
