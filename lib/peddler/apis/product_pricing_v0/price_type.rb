# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricingV0
      # Schema for item's price information, including listing price, shipping price, and Amazon points.
      PriceType = Structure.new do
        # @return [Money] The listing price of the item including any promotions that apply.
        attribute(:listing_price, Money, from: "ListingPrice")

        # @return [Money] The value calculated by adding ListingPrice + Shipping - Points. Note that if the landed price
        #   is not returned, the listing price represents the product with the lowest landed price.
        attribute?(:landed_price, Money, from: "LandedPrice")

        # @return [Points] The number of Amazon Points offered with the purchase of an item, and their monetary value.
        attribute?(:points, Points, from: "Points")

        # @return [Money] The shipping cost of the product. Note that the shipping cost is not always available.
        attribute?(:shipping, Money, from: "Shipping")
      end
    end
  end
end
