# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Promotions20251201
      # The key identifiers of an item.
      ItemIdentifier = Structure.new do
        # Amazon Standard Identification Number (ASIN).
        attribute?(:asin, String)

        # Stock Keeping Unit (SKU).
        attribute?(:sku, String)
      end
    end
  end
end
