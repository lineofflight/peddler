# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
      # A promotion applicable to the offer.
      Promotion = Structure.new do
        # @return [PromotionSavings] The savings applied by the promotion, including discount amount, percentage off,
        #   and discounted price.
        attribute(:promotion_savings, PromotionSavings, null: false, from: "promotionSavings")

        # @return [String] The type of promotion, categorized by the customer-facing experience.
        attribute(:promotion_type, String, null: false, from: "promotionType")

        # @return [PurchaseRequirements] Purchase requirements for BASKET_BUILDING promotions. Defines what customers
        #   must buy to qualify.
        attribute?(:purchase_requirements, PurchaseRequirements, from: "purchaseRequirements")
      end
    end
  end
end
