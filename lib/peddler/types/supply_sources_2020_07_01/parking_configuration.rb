# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module SupplySources20200701
      # The parking configuration.
      ParkingConfiguration = Structure.new do
        # @return [String] The type of cost at parking location.
        attribute?(:parking_cost_type, String, from: "parkingCostType")

        # @return [String] The type of parking spot identification used at parking location.
        attribute?(:parking_spot_identification_type, String, from: "parkingSpotIdentificationType")

        # @return [Integer] The number of parking spots.
        attribute?(:number_of_parking_spots, Integer, from: "numberOfParkingSpots")
      end
    end
  end
end
