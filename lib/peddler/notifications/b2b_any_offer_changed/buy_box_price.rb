# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module B2BAnyOfferChanged
      BuyBoxPrice = Structure.new do
        # @return [String]
        attribute(:condition, String, from: "Condition")

        # @return [Money]
        attribute(:listing_price, Money, from: "ListingPrice")

        # @return [String]
        attribute(:offer_type, String, from: "OfferType")

        # @return [String]
        attribute(:quantity_tier, String, from: "QuantityTier")

        # @return [String]
        attribute?(:discount_type, String, from: "DiscountType")

        # @return [Money]
        attribute?(:landed_price, Money, from: "LandedPrice")

        # @return [Points]
        attribute?(:points, Points, from: "Points")

        # @return [String] The seller identifier for the offer
        attribute?(:seller_id, String, from: "SellerId")

        # @return [Money]
        attribute?(:shipping, Money, from: "Shipping")
      end
    end
  end
end
