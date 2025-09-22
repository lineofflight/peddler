# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v1/create_shipment_result"
require "peddler/types/shipping_v1/error"

module Peddler
  module Types
    module ShippingV1
      # The response schema for the createShipment operation.
      CreateShipmentResponse = Structure.new do
        # @return [CreateShipmentResult] The payload for createShipment operation
        attribute(:payload, CreateShipmentResult)

        # @return [Array<Error>] Encountered errors for the operation.
        attribute(:errors, [Error])
      end
    end
  end
end
