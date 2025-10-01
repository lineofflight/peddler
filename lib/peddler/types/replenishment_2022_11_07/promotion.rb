# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/replenishment_2022_11_07/discount_funding"

module Peddler
  module Types
    module Replenishment20221107
      # Offer promotions to include in the result filter criteria.
      Promotion = Structure.new do
        # @return [DiscountFunding] A base discount set by Amazon on the offer.
        attribute?(:amazon_funded_base_discount, DiscountFunding, from: "amazonFundedBaseDiscount")

        # @return [DiscountFunding] A tiered discount set by Amazon on the offer.
        attribute?(:amazon_funded_tiered_discount, DiscountFunding, from: "amazonFundedTieredDiscount")

        # @return [DiscountFunding] A base discount set by the selling partner on the offer.
        attribute?(:selling_partner_funded_base_discount, DiscountFunding, from: "sellingPartnerFundedBaseDiscount")

        # @return [DiscountFunding] A tiered discount set by the selling partner on the offer.
        attribute?(:selling_partner_funded_tiered_discount, DiscountFunding, from: "sellingPartnerFundedTieredDiscount")
      end
    end
  end
end
