# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Replenishment20221107
      # Offer promotions to include in the result filter criteria.
      Promotion = Structure.new do
        # A base discount set by Amazon on the offer.
        attribute?(:amazon_funded_base_discount, DiscountFunding, from: "amazonFundedBaseDiscount")

        # A tiered discount set by Amazon on the offer.
        attribute?(:amazon_funded_tiered_discount, DiscountFunding, from: "amazonFundedTieredDiscount")

        # A base discount set by the selling partner on the offer.
        attribute?(:selling_partner_funded_base_discount, DiscountFunding, from: "sellingPartnerFundedBaseDiscount")

        # A tiered discount set by the selling partner on the offer.
        attribute?(:selling_partner_funded_tiered_discount, DiscountFunding, from: "sellingPartnerFundedTieredDiscount")
      end
    end
  end
end
