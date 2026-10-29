# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # A dimension of a package.
      Dimension = Structure.new do
        # @return [String] The unit of measurement of the dimension. Known values: `CM`, `M`, `IN`.
        attribute(:dimension_unit, String, null: false, from: "dimensionUnit")

        # @return [Float] The numerical value of the dimension. Must be a positive value.
        attribute(:value, Float, null: false)
      end
    end
  end
end
