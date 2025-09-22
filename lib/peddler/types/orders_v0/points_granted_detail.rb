# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"

module Peddler
  module Types
    module OrdersV0
      # The number of Amazon Points offered with the purchase of an item, and their monetary value.
      PointsGrantedDetail = Structure.new do
        # @return [Integer] The number of Amazon Points granted with the purchase of an item.
        attribute(:points_number, Integer, from: "PointsNumber")

        # @return [Money] The monetary value of the Amazon Points granted.
        attribute(:points_monetary_value, Money, from: "PointsMonetaryValue")
      end
    end
  end
end
