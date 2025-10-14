# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV1
      # The response schema for the createShipment operation.
      CreateShipmentResponse = Structure.new do
        # @return [Array<Error>] Encountered errors for the operation.
        attribute?(:errors, [Error])

        # @return [CreateShipmentResult] The payload for createShipment operation
        attribute?(:payload, CreateShipmentResult)
      end
    end
  end
end
