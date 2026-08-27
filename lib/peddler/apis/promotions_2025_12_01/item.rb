# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Promotions20251201
      # An item in the Amazon catalog for promotion selection.
      Item = Structure.new do
        # @return [String] The Amazon Standard Identification Number (ASIN) is the unique identifier for an item in the
        #   Amazon catalog.
        attribute?(:asin, String)

        # @return [ItemBenefit] Item-level benefit configuration. This only applies to `DEAL` and `PRICE_DISCOUNT`
        #   promotion types.
        attribute?(:benefit, ItemBenefit)

        # @return [Budget] Item-level budget configuration. This only applies to `DEAL` and `PRICE_DISCOUNT` promotion
        #   types.
        attribute?(:budget, Budget)

        # @return [String] The Stock Keeping Unit (SKU).
        attribute?(:sku, String)
      end
    end
  end
end
