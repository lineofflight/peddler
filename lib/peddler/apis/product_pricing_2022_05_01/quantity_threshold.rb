# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
      # Quantity-based purchase conditions for basket building promotions.
      QuantityThreshold = Structure.new do
        # @return [Integer] Number of items required to meet this purchase condition.
        attribute(:quantity, Integer, null: false)

        # @return [String] Indicates how the quantity requirement is evaluated. Possible values include:
        #
        # - AT_LEAST: The customer must purchase at least the specified quantity of items to qualify for the benefit.
        # - FOR_EACH: The benefit applies for every group of the specified quantity purchased (for example, the discount
        #   applies for each set of 2 items purchased).
        attribute(:type, String, null: false)
      end
    end
  end
end
