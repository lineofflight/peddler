# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentShippingV1
      # The weight.
      Weight = Structure.new do
        # @return [String] The unit of measurement.
        attribute(:unit_of_measure, String, from: "unitOfMeasure")

        # @return [String] The measurement value.
        attribute(:value, String)
      end
    end
  end
end
