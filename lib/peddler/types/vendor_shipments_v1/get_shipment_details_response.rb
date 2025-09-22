# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_shipments_v1/shipment_details"
require "peddler/types/vendor_shipments_v1/error"

module Peddler
  module Types
    module VendorShipmentsV1
      # The response schema for the GetShipmentDetails operation.
      GetShipmentDetailsResponse = Structure.new do
        # @return [ShipmentDetails]
        attribute(:payload, ShipmentDetails)

        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
