# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v1/error"
require "peddler/types/shipping_v1/shipment"

module Peddler
  module Types
    module ShippingV1
      # The response schema for the getShipment operation.
      GetShipmentResponse = Structure.new do
        # @return [Array<Error>] Encountered errors for the operation.
        attribute?(:errors, [Error])

        # @return [Shipment] The payload for getShipment operation
        attribute?(:payload, Shipment)
      end
    end
  end
end
