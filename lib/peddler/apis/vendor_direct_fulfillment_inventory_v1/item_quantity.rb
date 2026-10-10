# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentInventoryV1
      # Details of item quantity.
      ItemQuantity = Structure.new do
        # Unit of measure for the available quantity.
        attribute(:unit_of_measure, String, null: false, from: "unitOfMeasure")

        # Quantity of units available for a specific item.
        attribute?(:amount, Integer)
      end
    end
  end
end
