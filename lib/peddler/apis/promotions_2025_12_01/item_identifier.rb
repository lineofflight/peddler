# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Promotions20251201
      # The key identifiers of an item.
      ItemIdentifier = Structure.new do
        # @return [String] Amazon Standard Identification Number (ASIN).
        attribute?(:asin, String)

        # @return [String] Stock Keeping Unit (SKU).
        attribute?(:sku, String)
      end
    end
  end
end
