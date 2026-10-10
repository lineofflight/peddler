# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductFeesV0
      # Price information for an item, used to estimate fees.
      PriceToEstimateFees = Structure.new do
        # The price of the item.
        attribute(:listing_price, Money, null: false, from: "ListingPrice")

        # The number of Amazon Points offered with the purchase of an item.
        attribute?(:points, Points, from: "Points")

        # The shipping cost.
        attribute?(:shipping, Money, from: "Shipping")
      end
    end
  end
end
