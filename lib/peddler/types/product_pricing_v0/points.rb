# frozen_string_literal: true

require "peddler/money"
require "peddler/types/product_pricing_v0/money_type"

module Peddler
  module Types
    module ProductPricingV0
      # The number of Amazon Points offered with the purchase of an item, and their monetary value.
      Points = Structure.new do
        # @return [Integer] The number of points.
        attribute(:points_number, Integer, from: "PointsNumber")

        # @return [Money] The monetary value of the points.
        attribute(:points_monetary_value, Money, from: "PointsMonetaryValue")
      end
    end
  end
end
