# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # Response schema.
      CreateShipmentResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `createShipment` operation.
        attribute?(:errors, [Error])

        # @return [Shipment] Shipment information.
        attribute?(:payload, Shipment)
      end
    end
  end
end
