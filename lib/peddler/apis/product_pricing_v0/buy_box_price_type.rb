# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricingV0
      # Schema for an individual buybox price.
      BuyBoxPriceType = Structure.new do
        # The value calculated by adding ListingPrice + Shipping - Points.
        attribute(:landed_price, Money, null: false, from: "LandedPrice")

        # The price of the item.
        attribute(:listing_price, Money, null: false, from: "ListingPrice")

        # The shipping cost.
        attribute(:shipping, Money, null: false, from: "Shipping")

        # Indicates the condition of the item. For example: New, Used, Collectible, Refurbished, or Club.
        attribute(:condition, String, null: false)

        # The number of Amazon Points offered with the purchase of an item.
        attribute?(:points, Points, from: "Points")

        # Indicates the type of customer that the offer is valid for.<br><br>When the offer type is B2C in a quantity
        # discount, the seller is winning the Buy Box because others do not have inventory at that quantity, not because
        # they have a quantity discount on the ASIN. Known values: `B2C`, `B2B`.
        attribute?(:offer_type, String, from: "offerType")

        # Indicates the type of quantity discount this price applies to. Known values: `QUANTITY_DISCOUNT`.
        attribute?(:quantity_discount_type, String, from: "quantityDiscountType")

        # Indicates at what quantity this price becomes active.
        attribute?(:quantity_tier, Integer, from: "quantityTier")

        # The seller identifier for the offer.
        attribute?(:seller_id, String, from: "sellerId")
      end
    end
  end
end
