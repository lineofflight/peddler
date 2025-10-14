# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # A dimension of a package.
      Dimension = Structure.new do
        # @return [String] The unit of measurement of the dimension.
        attribute(:dimension_unit, String, from: "dimensionUnit")

        # @return [String] The numerical value of the dimension. Must be a positive value.
        attribute(:value, String)
      end
    end
  end
end
