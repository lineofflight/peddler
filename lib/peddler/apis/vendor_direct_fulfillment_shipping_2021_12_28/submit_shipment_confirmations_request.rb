# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentShipping20211228
      # The request schema for the submitShipmentConfirmations operation.
      SubmitShipmentConfirmationsRequest = Structure.new do
        # Array of `ShipmentConfirmation` objects. Each `ShipmentConfirmation` object represents the confirmation
        # details for a specific shipment.
        attribute?(:shipment_confirmations, [ShipmentConfirmation], from: "shipmentConfirmations")
      end
    end
  end
end
