# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_shipping_2021_12_28/shipment_confirmation"

module Peddler
  module Types
    module VendorDirectFulfillmentShipping20211228
      # The request schema for the submitShipmentConfirmations operation.
      SubmitShipmentConfirmationsRequest = Structure.new do
        # @return [Array<ShipmentConfirmation>] Array of `ShipmentConfirmation` objects. Each `ShipmentConfirmation`
        # object represents the confirmation details for a specific shipment.
        attribute(:shipment_confirmations, [ShipmentConfirmation], from: "shipmentConfirmations")
      end
    end
  end
end
