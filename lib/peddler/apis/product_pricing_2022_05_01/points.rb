# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
      # The number of Amazon Points that are offered with the purchase of an item and the monetary value of these
      # points.
      Points = Structure.new do
        # @return [Money] The monetary value of the Amazon Points.
        attribute?(:points_monetary_value, Money, from: "pointsMonetaryValue")

        # @return [Integer] The number of Amazon Points.
        attribute?(:points_number, Integer, from: "pointsNumber")
      end
    end
  end
end
