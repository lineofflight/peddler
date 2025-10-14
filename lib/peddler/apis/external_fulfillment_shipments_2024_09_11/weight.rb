# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # The weight of a package.
      Weight = Structure.new do
        # @return [String] The numerical value of the weight. Must be a positive value.
        attribute(:value, String)

        # @return [String] The unit of measurement of the weight.
        attribute(:weight_unit, String, from: "weightUnit")
      end
    end
  end
end
