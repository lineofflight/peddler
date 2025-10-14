# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class VendorShipmentsV1
      # Contractual or operational port or point relevant to the movement of the cargo.
      Stop = Structure.new do
        # @return [String] Provide the function code.
        attribute(:function_code, String, from: "functionCode")

        # @return [Time] Date and time of the arrival of the cargo.
        attribute?(:arrival_time, Time, from: "arrivalTime")

        # @return [Time] Date and time of the departure of the cargo.
        attribute?(:departure_time, Time, from: "departureTime")

        # @return [Location]
        attribute?(:location_identification, Location, from: "locationIdentification")
      end
    end
  end
end
