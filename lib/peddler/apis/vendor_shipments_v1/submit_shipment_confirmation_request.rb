# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorShipmentsV1
      # The request schema for the SubmitShipmentConfirmation operation.
      SubmitShipmentConfirmationRequest = Structure.new do
        # @return [ShipmentConfirmation] One shipment confirmation.
        attribute(:shipment_confirmation, ShipmentConfirmation, from: "shipmentConfirmation")
      end
    end
  end
end
