# frozen_string_literal: true

require "peddler/money"
require "peddler/types/product_pricing_v0/money_type"
require "peddler/types/product_pricing_v0/points"

module Peddler
  module Types
    module ProductPricingV0
      # Schema for an individual lowest price.
      LowestPriceType = Structure.new do
        # @return [String] Indicates the condition of the item. For example: New, Used, Collectible, Refurbished, or
        # Club.
        attribute(:condition, String)

        # @return [String] Indicates whether the item is fulfilled by Amazon or by the seller.
        attribute(:fulfillment_channel, String, from: "fulfillmentChannel")

        # @return [String] Indicates the type of customer that the offer is valid for.
        attribute(:offer_type, String, from: "offerType")

        # @return [Integer] Indicates at what quantity this price becomes active.
        attribute(:quantity_tier, Integer, from: "quantityTier")

        # @return [String] Indicates the type of quantity discount this price applies to.
        attribute(:quantity_discount_type, String, from: "quantityDiscountType")

        # @return [Money] The value calculated by adding ListingPrice + Shipping - Points.
        attribute(:landed_price, Money, from: "LandedPrice")

        # @return [Money] The price of the item.
        attribute(:listing_price, Money, from: "ListingPrice")

        # @return [Money] The shipping cost.
        attribute(:shipping, Money, from: "Shipping")

        # @return [Points] The number of Amazon Points offered with the purchase of an item.
        attribute(:points, Points, from: "Points")
      end
    end
  end
end
