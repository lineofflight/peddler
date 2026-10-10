# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # Geographic coordinates.
      Geocodes = Structure.new do
        # The latitude coordinate.
        attribute(:latitude, String, null: false)

        # The longitude coordinate.
        attribute(:longitude, String, null: false)

        # The elevation in meters.
        attribute?(:elevation, String)
      end
    end
  end
end
