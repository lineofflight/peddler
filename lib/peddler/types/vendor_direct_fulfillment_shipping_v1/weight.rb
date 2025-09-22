# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module VendorDirectFulfillmentShippingV1
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
