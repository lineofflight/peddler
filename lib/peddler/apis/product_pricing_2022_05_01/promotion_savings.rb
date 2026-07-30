# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
      # Details about the savings applied by the promotion.
      PromotionSavings = Structure.new do
        # @return [PromotionDiscount] The discount applied by the promotion.
        attribute?(:discount, PromotionDiscount)

        # @return [Money] The final price after the promotion is applied.
        attribute?(:discounted_price, Money, from: "discountedPrice")
      end
    end
  end
end
