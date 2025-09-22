# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "peddler/types/product_fees_v0/points"

module Peddler
  module Types
    module ProductFeesV0
      # Price information for an item, used to estimate fees.
      PriceToEstimateFees = Structure.new do
        # @return [Types::Money] The price of the item.
        attribute(:listing_price, Types::Money, from: "ListingPrice")

        # @return [Types::Money] The shipping cost.
        attribute(:shipping, Types::Money, from: "Shipping")

        # @return [Points] The number of Amazon Points offered with the purchase of an item.
        attribute(:points, Points, from: "Points")
      end
    end
  end
end
