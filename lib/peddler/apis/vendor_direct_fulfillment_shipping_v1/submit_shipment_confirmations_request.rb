# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentShippingV1
      # The request schema for the submitShipmentConfirmations operation.
      SubmitShipmentConfirmationsRequest = Structure.new do
        # @return [Array<ShipmentConfirmation>] Array of ShipmentConfirmation objects, each representing confirmation
        # details for a specific shipment.
        attribute?(:shipment_confirmations, [ShipmentConfirmation], from: "shipmentConfirmations")
      end
    end
  end
end
