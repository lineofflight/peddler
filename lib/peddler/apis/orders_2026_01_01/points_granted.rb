# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Information about Amazon Points awarded with an item purchase.
      PointsGranted = Structure.new do
        # @return [Money] Cash equivalent value of the awarded Amazon Points.
        attribute?(:points_monetary_value, Money, from: "pointsMonetaryValue")

        # @return [Integer] Total number of Amazon Points granted to the customer's account for this item purchase.
        attribute?(:points_number, Integer, from: "pointsNumber")
      end
    end
  end
end
