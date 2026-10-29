# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # Geographic coordinates.
      Geocodes = Structure.new do
        # @return [Float] The latitude coordinate.
        attribute(:latitude, Float, null: false)

        # @return [Float] The longitude coordinate.
        attribute(:longitude, Float, null: false)

        # @return [Float] The elevation in meters.
        attribute?(:elevation, Float)
      end
    end
  end
end
