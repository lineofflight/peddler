# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricingV0
      # Contains pricing information that includes special pricing when buying in bulk.
      QuantityDiscountPriceType = Structure.new do
        # @return [Money] The price at this quantity tier.
        attribute(:listing_price, Money, null: false, from: "listingPrice")

        # @return [String] Indicates the type of quantity discount this price applies to.
        attribute(:quantity_discount_type, String, null: false, from: "quantityDiscountType")

        # @return [Integer] Indicates at what quantity this price becomes active.
        attribute(:quantity_tier, Integer, null: false, from: "quantityTier")
      end
    end
  end
end
