# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_shipments_v1/shipment_confirmation"

module Peddler
  module Types
    module VendorShipmentsV1
      # The request schema for the SubmitShipmentConfirmations operation.
      SubmitShipmentConfirmationsRequest = Structure.new do
        # @return [Array<ShipmentConfirmation>] A list of one or more shipment confirmations.
        attribute?(:shipment_confirmations, [ShipmentConfirmation], from: "shipmentConfirmations")
      end
    end
  end
end
