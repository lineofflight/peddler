# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # The latitude and longitude coordinates of the shipping address using the WGS84 coordinate system.
      GeoCoordinates = Structure.new do
        # @return [Float] The latitude coordinate of the shipping address using the WGS84 coordinate system.
        attribute?(:latitude, Float, from: "Latitude")

        # @return [Float] The longitude coordinate of the shipping address using the WGS84 coordinate system.
        attribute?(:longitude, Float, from: "Longitude")
      end
    end
  end
end
