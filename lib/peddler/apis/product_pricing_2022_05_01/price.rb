# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricing20220501
      # The schema for item's price information, including listing price, shipping price, and Amazon Points.
      Price = Structure.new do
        # The listing price for the item, excluding any promotions.
        attribute(:listing_price, Money, null: false, from: "listingPrice")

        # The number of Amazon Points that are offered with the purchase of an item and the monetary value of these
        # points.
        attribute?(:points, Points)

        # The shipping cost of the product. Note that the shipping cost is not always available.
        attribute?(:shipping_price, Money, from: "shippingPrice")
      end
    end
  end
end
