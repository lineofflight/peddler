# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "structure"

module Peddler
  module Types
    module ProductPricingV0
      # Contains pricing information that includes special pricing when buying in bulk.
      QuantityDiscountPriceType = Structure.new do
        # @return [Integer] Indicates at what quantity this price becomes active.
        attribute(:quantity_tier, Integer, from: "quantityTier")

        # @return [String] Indicates the type of quantity discount this price applies to.
        attribute(:quantity_discount_type, String, from: "quantityDiscountType")

        # @return [Money] The price at this quantity tier.
        attribute(:listing_price, Money, from: "listingPrice")
      end
    end
  end
end
