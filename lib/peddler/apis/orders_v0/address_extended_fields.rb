# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # Extended address fields for additional address components including the street name or number.
      #
      # Note: Available for grocery sellers and Brazil shipping addresses.
      AddressExtendedFields = Structure.new do
        # @return [String] The floor number/unit number in the building/private house number.
        attribute?(:complement, String, from: "Complement")

        # @return [GeoCoordinates] Latitude and longitude coordinates for the shipping address using the WGS84
        #   coordinate system.
        #
        # Note: Available for sellers that support geographic coordinates.
        attribute?(:geo_coordinates, GeoCoordinates, from: "GeoCoordinates")

        # @return [String] The neighborhood. This value is only used in some countries (such as Brazil).
        attribute?(:neighborhood, String, from: "Neighborhood")

        # @return [String] The street name.
        attribute?(:street_name, String, from: "StreetName")

        # @return [String] The house, building, or property number associated with the location's street address.
        attribute?(:street_number, String, from: "StreetNumber")
      end
    end
  end
end
