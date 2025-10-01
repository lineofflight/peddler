# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v1/error"
require "peddler/types/shipping_v1/purchase_shipment_result"

module Peddler
  module Types
    module ShippingV1
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
