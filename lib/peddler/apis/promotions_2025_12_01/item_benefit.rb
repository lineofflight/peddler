# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Promotions20251201
      # Item-level benefit configuration with pricing options. Applicable to `DEAL` and `PRICE_DISCOUNT` promotion
      # types, where each item can have its own distinct benefit. For `COUPON` and `BASKET_BUILDING` promotion types,
      # benefits are configured at the promotion level.
      ItemBenefit = Structure.new do
        # @return [String] The benefit type for item-level pricing.
        attribute(:type, String, null: false)

        # @return [Discount] The discount configuration when using `DISCOUNTED_PRICE` type.
        attribute?(:discount, Discount)

        # @return [Integer] The maximum number of uses per customer for this item benefit.
        attribute?(:per_customer_uses, Integer, from: "perCustomerUses")

        # @return [Money] Fixed price.
        attribute?(:price, Money)
      end
    end
  end
end
