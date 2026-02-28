# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module B2BAnyOfferChanged
      # Contains pricing information that includes special pricing when buying in bulk.
      QuantityDiscountPriceType = Structure.new do
        # @return [Money] The price at this quantity tier.
        attribute(:listing_price, Money, null: false, from: "ListingPrice")

        # @return [String] Indicates the type of quantity discount this price applies to.
        attribute(:quantity_discount_type, String, null: false, from: "QuantityDiscountType")

        # @return [Integer] Indicates at what quantity this price becomes active.
        attribute(:quantity_tier, Integer, null: false, from: "QuantityTier")
      end
    end
  end
end
