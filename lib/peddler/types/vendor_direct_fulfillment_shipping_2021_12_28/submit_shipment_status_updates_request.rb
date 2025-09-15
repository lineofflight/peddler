# frozen_string_literal: true

require "peddler/types/vendor_direct_fulfillment_shipping_2021_12_28/shipment_status_update"

module Peddler
  module Types
    module VendorDirectFulfillmentShipping20211228
      # The request schema for the `submitShipmentStatusUpdates` operation.
      SubmitShipmentStatusUpdatesRequest = Structure.new do
        # @return [Array<ShipmentStatusUpdate>] Contains a list of one or more `ShipmentStatusUpdate` objects. Each
        # `ShipmentStatusUpdate` object represents an update to the status of a specific shipment.
        attribute(:shipment_status_updates, [ShipmentStatusUpdate], from: "shipmentStatusUpdates")
      end
    end
  end
end
