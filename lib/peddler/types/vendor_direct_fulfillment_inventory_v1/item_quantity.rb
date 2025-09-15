# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module VendorDirectFulfillmentInventoryV1
      # Details of item quantity.
      ItemQuantity = Structure.new do
        # @return [Integer] Quantity of units available for a specific item.
        attribute(:amount, Integer)

        # @return [String] Unit of measure for the available quantity.
        attribute(:unit_of_measure, String, from: "unitOfMeasure")
      end
    end
  end
end
