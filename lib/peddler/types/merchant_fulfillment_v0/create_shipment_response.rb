# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/merchant_fulfillment_v0/error"
require "peddler/types/merchant_fulfillment_v0/shipment"

module Peddler
  module Types
    module MerchantFulfillmentV0
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
