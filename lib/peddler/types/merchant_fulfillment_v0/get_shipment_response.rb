# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/merchant_fulfillment_v0/error"
require "peddler/types/merchant_fulfillment_v0/shipment"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # Response schema.
      GetShipmentResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during this operation.
        attribute?(:errors, [Error])

        # @return [Shipment] The payload for the `getShipment` operation.
        attribute?(:payload, Shipment)
      end
    end
  end
end
