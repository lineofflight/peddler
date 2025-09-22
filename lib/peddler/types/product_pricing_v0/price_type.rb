# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "peddler/types/product_pricing_v0/money_type"
require "peddler/types/product_pricing_v0/points"

module Peddler
  module Types
    module ProductPricingV0
      # Schema for item's price information, including listing price, shipping price, and Amazon points.
      PriceType = Structure.new do
        # @return [Types::Money] The value calculated by adding ListingPrice + Shipping - Points. Note that if the
        # landed price is not returned, the listing price represents the product with the lowest landed price.
        attribute(:landed_price, Types::Money, from: "LandedPrice")

        # @return [Types::Money] The listing price of the item including any promotions that apply.
        attribute(:listing_price, Types::Money, from: "ListingPrice")

        # @return [Types::Money] The shipping cost of the product. Note that the shipping cost is not always available.
        attribute(:shipping, Types::Money, from: "Shipping")

        # @return [Points] The number of Amazon Points offered with the purchase of an item, and their monetary value.
        attribute(:points, Points, from: "Points")
      end
    end
  end
end
