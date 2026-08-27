# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Promotions20251201
      # Promotion-level benefit configuration. Applicable to `COUPON` and `BASKET_BUILDING` promotion types, where the
      # benefit applies uniformly across all items in the promotion. For `DEAL` and `PRICE_DISCOUNT` promotion types,
      # benefits are configured at the item level within each item in the selection.
      PromotionBenefit = Structure.new do
        # @return [Array<BenefitTier>] Progressive discount tiers offering increased benefits as customers purchase
        #   more. For example: buy 2 get 10% off, buy 3 get 15% off. For multi-tier `BASKET_BUILDING` promotions, each
        #   tier specifies additional purchase conditions and corresponding discounts beyond the first tier (defined in
        #   `benefit.discount` and `purchaseRequirements.condition`).
        attribute?(:additional_tiers, [BenefitTier], from: "additionalTiers")

        # @return [Integer] The quantity of items from the benefit selection that receive the discount after the
        #   customer satisfies purchase conditions. This property is specific to `BASKET_BUILDING` promotions.
        attribute?(:benefit_quantity, Integer, from: "benefitQuantity")

        # @return [Discount] The discount configuration for the promotion. For multi-tier `BASKET_BUILDING` promotions,
        #   this represents the first tier discount. Additional tier discounts are defined in `additionalTiers`.
        attribute?(:discount, Discount)

        # @return [Integer] The maximum number of uses per customer for this promotion.
        attribute?(:per_customer_uses, Integer, from: "perCustomerUses")

        # @return [String] Whether this benefit can be stacked with other promotions.
        attribute?(:stacking, String)
      end
    end
  end
end
