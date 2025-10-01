# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module SupplySources20200701
      # The parking configuration.
      ParkingConfiguration = Structure.new do
        # @return [Integer] The number of parking spots.
        attribute?(:number_of_parking_spots, Integer, from: "numberOfParkingSpots")

        # @return [String] The type of cost at parking location.
        attribute?(:parking_cost_type, String, from: "parkingCostType")

        # @return [String] The type of parking spot identification used at parking location.
        attribute?(:parking_spot_identification_type, String, from: "parkingSpotIdentificationType")
      end
    end
  end
end
