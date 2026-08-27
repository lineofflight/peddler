# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Promotions20251201
      # Minimum purchase requirements using quantity-based or amount-based conditions for basket building promotions.
      # You can specify conditions within purchase requirements and multi-tier benefit configurations. You must specify
      # exactly one of `quantityThreshold` or `amountThreshold`.
      PurchaseCondition = Structure.new do
        # @return [AmountThreshold] Amount-based purchase requirement. Specify this for minimum spend conditions.
        attribute?(:amount_threshold, AmountThreshold, from: "amountThreshold")

        # @return [QuantityThreshold] Quantity-based purchase requirement. Specify this for item count conditions.
        attribute?(:quantity_threshold, QuantityThreshold, from: "quantityThreshold")
      end
    end
  end
end
