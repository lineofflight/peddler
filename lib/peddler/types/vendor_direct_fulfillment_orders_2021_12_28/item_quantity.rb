# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module VendorDirectFulfillmentOrders20211228
      # Details of quantity ordered.
      ItemQuantity = Structure.new do
        # @return [Integer] Acknowledged quantity. This value should not be zero.
        attribute?(:amount, Integer)

        # @return [String] Unit of measure for the acknowledged quantity.
        attribute?(:unit_of_measure, String, from: "unitOfMeasure")
      end
    end
  end
end
