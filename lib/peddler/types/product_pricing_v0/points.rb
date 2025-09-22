# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"

module Peddler
  module Types
    module ProductPricingV0
      # The number of Amazon Points offered with the purchase of an item, and their monetary value.
      Points = Structure.new do
        # @return [Integer] The number of points.
        attribute(:points_number, Integer, from: "PointsNumber")

        # @return [Types::Money] The monetary value of the points.
        attribute(:points_monetary_value, Types::Money, from: "PointsMonetaryValue")
      end
    end
  end
end
