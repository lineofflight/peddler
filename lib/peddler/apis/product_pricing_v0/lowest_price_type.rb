# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricingV0
      # Schema for an individual lowest price.
      LowestPriceType = Structure.new do
        # The price of the item.
        attribute(:listing_price, Money, null: false, from: "ListingPrice")

        # Indicates the condition of the item. For example: New, Used, Collectible, Refurbished, or Club.
        attribute(:condition, String, null: false)

        # Indicates whether the item is fulfilled by Amazon or by the seller.
        attribute(:fulfillment_channel, String, null: false, from: "fulfillmentChannel")

        # The value calculated by adding ListingPrice + Shipping - Points.
        attribute?(:landed_price, Money, from: "LandedPrice")

        # The number of Amazon Points offered with the purchase of an item.
        attribute?(:points, Points, from: "Points")

        # The shipping cost.
        attribute?(:shipping, Money, from: "Shipping")

        # Indicates the type of customer that the offer is valid for. Known values: `B2C`, `B2B`.
        attribute?(:offer_type, String, from: "offerType")

        # Indicates the type of quantity discount this price applies to. Known values: `QUANTITY_DISCOUNT`.
        attribute?(:quantity_discount_type, String, from: "quantityDiscountType")

        # Indicates at what quantity this price becomes active.
        attribute?(:quantity_tier, Integer, from: "quantityTier")
      end
    end
  end
end
