# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # The drop-off location details for package handover.
      HandoverLocation = Structure.new do
        # The address of the drop-off location.
        attribute?(:address, Address)

        # The distance from the seller's location to the drop-off point.
        attribute?(:distance, Distance)

        # URL to the map that shows the drop-off location.
        attribute?(:map_url, String, from: "mapUrl")
      end
    end
  end
end
