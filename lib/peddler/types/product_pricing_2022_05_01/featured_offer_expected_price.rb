# frozen_string_literal: true

require "peddler/money"
require "peddler/types/product_pricing_2022_05_01/money_type"
require "peddler/types/product_pricing_2022_05_01/points"

module Peddler
  module Types
    module ProductPricing20220501
      # The item price at or below which the target offer may be featured.
      FeaturedOfferExpectedPrice = Structure.new do
        # @return [Money] A computed listing price at or below which a seller can expect to become the featured offer
        # (before applicable promotions).
        attribute(:listing_price, Money, from: "listingPrice")

        # @return [Points] The number of Amazon Points that are offered with the purchase of an item and the monetary
        # value of these points.
        attribute(:points, Points)
      end
    end
  end
end
