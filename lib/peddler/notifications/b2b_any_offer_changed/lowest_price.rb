# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module B2BAnyOfferChanged
      LowestPrice = Structure.new do
        # @return [String]
        attribute(:condition, String, null: false, from: "Condition")

        # @return [String]
        attribute(:fulfillment_channel, String, null: false, from: "FulfillmentChannel")

        # @return [Money]
        attribute(:listing_price, Money, null: false, from: "ListingPrice")

        # @return [String]
        attribute(:offer_type, String, null: false, from: "OfferType")

        # @return [String]
        attribute(:quantity_tier, String, null: false, from: "QuantityTier")

        # @return [String]
        attribute?(:discount_type, String, from: "DiscountType")

        # @return [Money]
        attribute?(:landed_price, Money, from: "LandedPrice")

        # @return [Points]
        attribute?(:points, Points, from: "Points")

        # @return [Money]
        attribute?(:shipping, Money, from: "Shipping")
      end
    end
  end
end
