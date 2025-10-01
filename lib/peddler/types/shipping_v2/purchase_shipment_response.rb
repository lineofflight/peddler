# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v2/purchase_shipment_result"

module Peddler
  module Types
    module ShippingV2
      # The response schema for the purchaseShipment operation.
      PurchaseShipmentResponse = Structure.new do
        # @return [PurchaseShipmentResult]
        attribute?(:payload, PurchaseShipmentResult)
      end
    end
  end
end
