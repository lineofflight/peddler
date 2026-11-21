# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Promotions20251201
      # Quantity-based purchase conditions for basket building promotions.
      QuantityThreshold = Structure.new do
        # The number of items required to meet this purchase condition.
        attribute(:quantity, Integer, null: false)

        # How the quantity requirement is evaluated. Known values: `AT_LEAST`, `FOR_EACH`.
        attribute(:type, String, null: false)
      end
    end
  end
end
