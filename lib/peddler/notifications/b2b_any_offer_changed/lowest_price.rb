# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module B2BAnyOfferChanged
      LowestPrice = Structure.new do
        attribute(:condition, String, null: false, from: "Condition")

        attribute(:fulfillment_channel, String, null: false, from: "FulfillmentChannel")

        attribute(:listing_price, Money, null: false, from: "ListingPrice")

        attribute(:offer_type, String, null: false, from: "OfferType")

        attribute(:quantity_tier, String, null: false, from: "QuantityTier")

        attribute?(:discount_type, String, from: "DiscountType")

        attribute?(:landed_price, Money, from: "LandedPrice")

        attribute?(:points, Points, from: "Points")

        attribute?(:shipping, Money, from: "Shipping")
      end
    end
  end
end
