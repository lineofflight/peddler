# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorOrdersV1
      # Details of quantity ordered.
      ItemQuantity = Structure.new do
        # Acknowledged quantity. This value should not be zero.
        attribute?(:amount, Integer)

        # Unit of measure for the acknowledged quantity.
        attribute?(:unit_of_measure, String, from: "unitOfMeasure")

        # The case size, in the event that we ordered using cases.
        attribute?(:unit_size, Integer, from: "unitSize")
      end
    end
  end
end
