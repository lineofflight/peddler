# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricing20220501
      # A promotion applicable to the offer.
      Promotion = Structure.new do
        # The savings applied by the promotion, including discount amount, percentage off, and discounted price.
        attribute(:promotion_savings, PromotionSavings, null: false, from: "promotionSavings")

        # The type of promotion, categorized by the customer-facing experience.
        attribute(:promotion_type, String, null: false, from: "promotionType")

        # Purchase requirements for BASKET_BUILDING promotions. Defines what customers must buy to qualify.
        attribute?(:purchase_requirements, PurchaseRequirements, from: "purchaseRequirements")
      end
    end
  end
end
