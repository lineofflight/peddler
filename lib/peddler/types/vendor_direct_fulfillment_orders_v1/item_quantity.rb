# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module VendorDirectFulfillmentOrdersV1
      # Details of quantity ordered.
      ItemQuantity = Structure.new do
        # @return [Integer] Acknowledged quantity. This value should not be zero.
        attribute(:amount, Integer)

        # @return [String] Unit of measure for the acknowledged quantity.
        attribute(:unit_of_measure, String, from: "unitOfMeasure")
      end
    end
  end
end
