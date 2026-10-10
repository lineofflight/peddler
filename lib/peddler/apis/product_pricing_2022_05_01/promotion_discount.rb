# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricing20220501
      # Discount details applied by the promotion.
      PromotionDiscount = Structure.new do
        # The monetary amount discounted from the original price. Only valid when type is AMOUNT_OFF.
        attribute?(:amount_off, Money, from: "amountOff")

        # The percentage discount applied to the original price (1-100). Only valid when type is PERCENTAGE_OFF.
        attribute?(:percent_off, Float, from: "percentOff")

        # The type of discount off, categorized by the customer-facing experience.
        attribute?(:type, String)
      end
    end
  end
end
