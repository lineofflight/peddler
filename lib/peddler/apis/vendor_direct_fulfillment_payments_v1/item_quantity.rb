# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentPaymentsV1
      # Details of item quantity.
      ItemQuantity = Structure.new do
        # Quantity of units available for a specific item.
        attribute(:amount, Integer, null: false)

        # Unit of measure for the available quantity.
        attribute(:unit_of_measure, String, null: false, from: "unitOfMeasure")
      end
    end
  end
end
