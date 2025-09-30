# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v1/purchase_shipment_result"
require "peddler/types/shipping_v1/error"

module Peddler
  module Types
    module ShippingV1
      # The response schema for the purchaseShipment operation.
      PurchaseShipmentResponse = Structure.new do
        # @return [PurchaseShipmentResult] The payload for purchaseShipment operation
        attribute?(:payload, PurchaseShipmentResult)

        # @return [Array<Error>] Encountered errors for the operation.
        attribute?(:errors, [Error])
      end
    end
  end
end
