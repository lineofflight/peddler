# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_shipments_v1/error"
require "peddler/types/vendor_shipments_v1/shipment_details"

module Peddler
  module Types
    module VendorShipmentsV1
      # The response schema for the GetShipmentDetails operation.
      GetShipmentDetailsResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [ShipmentDetails]
        attribute?(:payload, ShipmentDetails)
      end
    end
  end
end
