# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v2/cancel_shipment_result"

module Peddler
  module Types
    module ShippingV2
      # Response schema for the cancelShipment operation.
      CancelShipmentResponse = Structure.new do
        # @return [CancelShipmentResult]
        attribute(:payload, CancelShipmentResult)
      end
    end
  end
end
