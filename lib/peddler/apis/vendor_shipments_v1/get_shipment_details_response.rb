# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorShipmentsV1
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
