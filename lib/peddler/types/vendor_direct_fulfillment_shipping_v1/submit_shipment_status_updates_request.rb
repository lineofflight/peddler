# frozen_string_literal: true

require "peddler/types/vendor_direct_fulfillment_shipping_v1/shipment_status_update"

module Peddler
  module Types
    module VendorDirectFulfillmentShippingV1
      # Represents the request payload for submitting updates to the status of shipments, containing an array of one or
      # more ShipmentStatusUpdate objects.
      SubmitShipmentStatusUpdatesRequest = Structure.new do
        # @return [Array<ShipmentStatusUpdate>] Contains a list of one or more ShipmentStatusUpdate objects, each
        # representing an update to the status of a specific shipment.
        attribute(:shipment_status_updates, [ShipmentStatusUpdate], from: "shipmentStatusUpdates")
      end
    end
  end
end
