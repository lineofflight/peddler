# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorInvoicesV1
      # Details of quantity.
      ItemQuantity = Structure.new do
        # @return [Integer] Quantity of an item. This value should not be zero.
        attribute(:amount, Integer, null: false)

        # @return [String] Unit of measure for the quantity.
        attribute(:unit_of_measure, String, null: false, from: "unitOfMeasure")

        # @return [TotalWeight]
        attribute?(:total_weight, TotalWeight, from: "totalWeight")

        # @return [Integer] The case size, if the unit of measure value is Cases.
        attribute?(:unit_size, Integer, from: "unitSize")
      end
    end
  end
end
