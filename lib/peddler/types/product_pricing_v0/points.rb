# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/money"
require "structure"

module Peddler
  module Types
    module ProductPricingV0
      # The number of Amazon Points offered with the purchase of an item, and their monetary value.
      Points = Structure.new do
        # @return [Money] The monetary value of the points.
        attribute?(:points_monetary_value, Money, from: "PointsMonetaryValue")

        # @return [Integer] The number of points.
        attribute?(:points_number, Integer, from: "PointsNumber")
      end
    end
  end
end
