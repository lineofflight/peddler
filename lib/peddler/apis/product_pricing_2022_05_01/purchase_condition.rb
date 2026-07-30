# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
      # Specifies minimum purchase requirements using quantity-based or amount-based conditions for basket building
      # promotions. Used in purchase requirements to specify conditions within those configurations. Exactly one of
      # quantityThreshold or amountThreshold must be specified.
      PurchaseCondition = Structure.new do
        # @return [AmountThreshold] Amount-based purchase conditions for basket building promotions. Customers must
        #   purchase a minimum amount for the promotion to apply
        attribute?(:amount_threshold, AmountThreshold, from: "amountThreshold")

        # @return [QuantityThreshold] Quantity-based purchase conditions for basket building promotions. Customer must
        #   purchase at least the specified quantity of items
        attribute?(:quantity_threshold, QuantityThreshold, from: "quantityThreshold")
      end
    end
  end
end
