# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_invoices_v1/total_weight"

module Peddler
  module Types
    module VendorInvoicesV1
      # Details of quantity.
      ItemQuantity = Structure.new do
        # @return [Integer] Quantity of an item. This value should not be zero.
        attribute(:amount, Integer)

        # @return [String] Unit of measure for the quantity.
        attribute(:unit_of_measure, String, from: "unitOfMeasure")

        # @return [Integer] The case size, if the unit of measure value is Cases.
        attribute(:unit_size, Integer, from: "unitSize")

        # @return [TotalWeight]
        attribute(:total_weight, TotalWeight, from: "totalWeight")
      end
    end
  end
end
