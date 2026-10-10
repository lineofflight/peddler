# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MerchantFulfillmentV0
      # Response schema.
      CancelShipmentResponse = Structure.new do
        # One or more unexpected errors occurred during the `cancelShipment` operation.
        attribute?(:errors, [Error])

        # The payload for the `cancelShipment` operation.
        attribute?(:payload, Shipment)
      end
    end
  end
end
