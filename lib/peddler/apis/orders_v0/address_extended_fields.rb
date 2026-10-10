# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module OrdersV0
      # Extended address fields for additional address components including the street name or number.
      #
      # Note: Available for grocery sellers and Brazil shipping addresses.
      AddressExtendedFields = Structure.new do
        # The floor number/unit number in the building/private house number.
        attribute?(:complement, String, from: "Complement")

        # Latitude and longitude coordinates for the shipping address using the WGS84 coordinate system.
        #
        # Note: Available for sellers that support geographic coordinates.
        attribute?(:geo_coordinates, GeoCoordinates, from: "GeoCoordinates")

        # The neighborhood. This value is only used in some countries (such as Brazil).
        attribute?(:neighborhood, String, from: "Neighborhood")

        # The street name.
        attribute?(:street_name, String, from: "StreetName")

        # The house, building, or property number associated with the location's street address.
        attribute?(:street_number, String, from: "StreetNumber")
      end
    end
  end
end
