# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorShipmentsV1
      # The response schema for the GetShipmentDetails operation.
      GetShipmentDetailsResponse = Structure.new do
        attribute?(:errors, [Error])

        attribute?(:payload, ShipmentDetails)
      end
    end
  end
end
