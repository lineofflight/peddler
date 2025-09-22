# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "peddler/types/product_fees_v0/money_type"

module Peddler
  module Types
    module ProductFeesV0
      # The number of Amazon Points offered with the purchase of an item.The Amazon Points program is only available in
      # Japan.
      Points = Structure.new do
        # @return [Integer] The number of Amazon Points
        attribute(:points_number, Integer, from: "PointsNumber")

        # @return [Types::Money]
        attribute(:points_monetary_value, Types::Money, from: "PointsMonetaryValue")
      end
    end
  end
end
