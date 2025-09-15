# frozen_string_literal: true

require "peddler/types/shipping_v1/shipment"
require "peddler/types/shipping_v1/error"

module Peddler
  module Types
    module ShippingV1
      # The response schema for the getShipment operation.
      GetShipmentResponse = Structure.new do
        # @return [Shipment] The payload for getShipment operation
        attribute(:payload, Shipment)

        # @return [Array<Error>] Encountered errors for the operation.
        attribute(:errors, [Error])
      end
    end
  end
end
