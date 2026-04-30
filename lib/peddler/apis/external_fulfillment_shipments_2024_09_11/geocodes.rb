# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # Geographic coordinates.
      Geocodes = Structure.new do
        # @return [String] The latitude coordinate.
        attribute(:latitude, String, null: false)

        # @return [String] The longitude coordinate.
        attribute(:longitude, String, null: false)

        # @return [String] The elevation in meters.
        attribute?(:elevation, String)
      end
    end
  end
end
