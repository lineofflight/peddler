# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # A distance measurement.
      Distance = Structure.new do
        # @return [String] The unit of measurement of the distance.
        attribute(:distance_unit, String, null: false, from: "distanceUnit")

        # @return [String] The numerical value of the distance.
        attribute(:value, String, null: false)
      end
    end
  end
end
