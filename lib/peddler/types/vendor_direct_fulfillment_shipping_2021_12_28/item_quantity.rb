# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module VendorDirectFulfillmentShipping20211228
      # Details of item quantity.
      ItemQuantity = Structure.new do
        # @return [Integer] Quantity of units shipped for a specific item at a shipment level. If the item is present
        # only in certain packages or pallets within the shipment, please provide this at the appropriate package or
        # pallet level.
        attribute(:amount, Integer)

        # @return [String] Unit of measure for the shipped quantity.
        attribute(:unit_of_measure, String, from: "unitOfMeasure")
      end
    end
  end
end
