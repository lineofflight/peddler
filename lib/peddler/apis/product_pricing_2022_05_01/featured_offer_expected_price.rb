# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
      # The item price at or below which the target offer may be featured.
      FeaturedOfferExpectedPrice = Structure.new do
        # @return [Money] A computed listing price at or below which a seller can expect to become the featured offer
        #   (before applicable promotions).
        attribute(:listing_price, Money, from: "listingPrice")

        # @return [Points] The number of Amazon Points that are offered with the purchase of an item and the monetary
        #   value of these points.
        attribute?(:points, Points)
      end
    end
  end
end
