# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV1
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
