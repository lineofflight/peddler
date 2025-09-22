# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"

module Peddler
  module Types
    module ProductFeesV0
      # The number of Amazon Points offered with the purchase of an item.The Amazon Points program is only available in
      # Japan.
      Points = Structure.new do
        # @return [Integer] The number of Amazon Points
        attribute(:points_number, Integer, from: "PointsNumber")

        # @return [Money]
        attribute(:points_monetary_value, Money, from: "PointsMonetaryValue")
      end
    end
  end
end
