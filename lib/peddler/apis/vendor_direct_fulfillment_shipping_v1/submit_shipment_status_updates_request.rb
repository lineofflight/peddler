# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentShippingV1
      # Represents the request payload for submitting updates to the status of shipments, containing an array of one or
      # more ShipmentStatusUpdate objects.
      SubmitShipmentStatusUpdatesRequest = Structure.new do
        # @return [Array<ShipmentStatusUpdate>] Contains a list of one or more ShipmentStatusUpdate objects, each
        #   representing an update to the status of a specific shipment.
        attribute?(:shipment_status_updates, [ShipmentStatusUpdate], from: "shipmentStatusUpdates")
      end
    end
  end
end
