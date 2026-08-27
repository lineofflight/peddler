# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Promotions20251201
      # Quantity-based purchase conditions for basket building promotions.
      QuantityThreshold = Structure.new do
        # @return [Integer] The number of items required to meet this purchase condition.
        attribute(:quantity, Integer, null: false)

        # @return [String] How the quantity requirement is evaluated.
        attribute(:type, String, null: false)
      end
    end
  end
end
