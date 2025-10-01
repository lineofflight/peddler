# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/money"
require "peddler/types/product_pricing_2022_05_01/points"

module Peddler
  module Types
    module ProductPricing20220501
      # The schema for item's price information, including listing price, shipping price, and Amazon Points.
      Price = Structure.new do
        # @return [Money] The listing price for the item, excluding any promotions.
        attribute(:listing_price, Money, from: "listingPrice")

        # @return [Points] The number of Amazon Points that are offered with the purchase of an item and the monetary
        # value of these points.
        attribute?(:points, Points)

        # @return [Money] The shipping cost of the product. Note that the shipping cost is not always available.
        attribute?(:shipping_price, Money, from: "shippingPrice")
      end
    end
  end
end
