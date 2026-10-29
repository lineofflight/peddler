# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
      # Offer details for a listings item for the specified Amazon store.
      ItemOfferByMarketplace = Structure.new do
        # @return [String] Amazon store identifier.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [String] The listings item's offer type. Known values: `B2C`, `B2B`.
        attribute(:offer_type, String, null: false, from: "offerType")

        # @return [Money] The purchase price of the listings item.
        attribute(:price, Money, null: false)

        # @return [Audience] Buyer segment or program this offer is applicable to.
        attribute?(:audience, Audience)

        # @return [Points]
        attribute?(:points, Points)

        # @return [QuantityDiscountPlan] The quantity discount plan applicable to this offer. A quantity discount plan
        #   defines discounts based on the purchase quantity, offered either as fixed prices or as percentage discounts
        #   across quantity tiers. Returned only when the offer has an active quantity discount schedule.
        attribute?(:quantity_discount_plan, QuantityDiscountPlan, from: "quantityDiscountPlan")

        # @return [ReplenishmentDiscount] The seller-funded discount configured on this offer for the Subscribe & Save
        #   program. Returned only for offers that have a configured Subscribe & Save discount.
        attribute?(:replenishment_discount, ReplenishmentDiscount, from: "replenishmentDiscount")
      end
    end
  end
end
