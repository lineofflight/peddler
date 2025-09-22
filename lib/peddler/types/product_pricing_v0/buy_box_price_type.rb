# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "peddler/types/product_pricing_v0/points"

module Peddler
  module Types
    module ProductPricingV0
      # Schema for an individual buybox price.
      BuyBoxPriceType = Structure.new do
        # @return [String] Indicates the condition of the item. For example: New, Used, Collectible, Refurbished, or
        # Club.
        attribute(:condition, String)

        # @return [String] Indicates the type of customer that the offer is valid for.<br><br>When the offer type is B2C
        # in a quantity discount, the seller is winning the Buy Box because others do not have inventory at that
        # quantity, not because they have a quantity discount on the ASIN.
        attribute(:offer_type, String, from: "offerType")

        # @return [Integer] Indicates at what quantity this price becomes active.
        attribute(:quantity_tier, Integer, from: "quantityTier")

        # @return [String] Indicates the type of quantity discount this price applies to.
        attribute(:quantity_discount_type, String, from: "quantityDiscountType")

        # @return [Types::Money] The value calculated by adding ListingPrice + Shipping - Points.
        attribute(:landed_price, Types::Money, from: "LandedPrice")

        # @return [Types::Money] The price of the item.
        attribute(:listing_price, Types::Money, from: "ListingPrice")

        # @return [Types::Money] The shipping cost.
        attribute(:shipping, Types::Money, from: "Shipping")

        # @return [Points] The number of Amazon Points offered with the purchase of an item.
        attribute(:points, Points, from: "Points")

        # @return [String] The seller identifier for the offer.
        attribute(:seller_id, String, from: "sellerId")
      end
    end
  end
end
