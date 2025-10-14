# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV1
      # The response schema for the purchaseShipment operation.
      PurchaseShipmentResponse = Structure.new do
        # @return [Array<Error>] Encountered errors for the operation.
        attribute?(:errors, [Error])

        # @return [PurchaseShipmentResult] The payload for purchaseShipment operation
        attribute?(:payload, PurchaseShipmentResult)
      end
    end
  end
end
