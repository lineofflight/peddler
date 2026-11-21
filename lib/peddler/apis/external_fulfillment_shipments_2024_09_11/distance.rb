# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # A distance measurement.
      Distance = Structure.new do
        # The unit of measurement of the distance. Known values: `MI`, `KM`.
        attribute(:distance_unit, String, null: false, from: "distanceUnit")

        # The numerical value of the distance.
        attribute(:value, Float, null: false)
      end
    end
  end
end
