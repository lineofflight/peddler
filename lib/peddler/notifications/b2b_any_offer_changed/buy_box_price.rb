# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module B2BAnyOfferChanged
      BuyBoxPrice = Structure.new do
        attribute(:condition, String, null: false, from: "Condition")

        attribute(:listing_price, Money, null: false, from: "ListingPrice")

        attribute(:offer_type, String, null: false, from: "OfferType")

        attribute(:quantity_tier, String, null: false, from: "QuantityTier")

        attribute?(:discount_type, String, from: "DiscountType")

        attribute?(:landed_price, Money, from: "LandedPrice")

        attribute?(:points, Points, from: "Points")

        # The seller identifier for the offer
        attribute?(:seller_id, String, from: "SellerId")

        attribute?(:shipping, Money, from: "Shipping")
      end
    end
  end
end
