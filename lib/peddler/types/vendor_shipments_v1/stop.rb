# frozen_string_literal: true

require "peddler/types/vendor_shipments_v1/location"

module Peddler
  module Types
    module VendorShipmentsV1
      # Contractual or operational port or point relevant to the movement of the cargo.
      Stop = Structure.new do
        # @return [String] Provide the function code.
        attribute(:function_code, String, from: "functionCode")

        # @return [Location]
        attribute(:location_identification, Location, from: "locationIdentification")

        # @return [String] Date and time of the arrival of the cargo.
        attribute(:arrival_time, String, from: "arrivalTime")

        # @return [String] Date and time of the departure of the cargo.
        attribute(:departure_time, String, from: "departureTime")
      end
    end
  end
end
