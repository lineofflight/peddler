# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "peddler/types/product_pricing_2022_05_01/money_type"

module Peddler
  module Types
    module ProductPricing20220501
      # The number of Amazon Points that are offered with the purchase of an item and the monetary value of these
      # points.
      Points = Structure.new do
        # @return [Integer] The number of Amazon Points.
        attribute(:points_number, Integer, from: "pointsNumber")

        # @return [Types::Money] The monetary value of the Amazon Points.
        attribute(:points_monetary_value, Types::Money, from: "pointsMonetaryValue")
      end
    end
  end
end
