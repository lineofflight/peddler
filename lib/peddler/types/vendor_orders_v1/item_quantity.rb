# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module VendorOrdersV1
      # Details of quantity ordered.
      ItemQuantity = Structure.new do
        # @return [Integer] Acknowledged quantity. This value should not be zero.
        attribute(:amount, Integer)

        # @return [String] Unit of measure for the acknowledged quantity.
        attribute(:unit_of_measure, String, from: "unitOfMeasure")

        # @return [Integer] The case size, in the event that we ordered using cases.
        attribute(:unit_size, Integer, from: "unitSize")
      end
    end
  end
end
