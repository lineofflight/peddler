# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/merchant_fulfillment_v0/shipment"
require "peddler/types/merchant_fulfillment_v0/error"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # Response schema.
      CreateShipmentResponse = Structure.new do
        # @return [Shipment] Shipment information.
        attribute(:payload, Shipment)

        # @return [Array<Error>] One or more unexpected errors occurred during the `createShipment` operation.
        attribute(:errors, [Error])
      end
    end
  end
end
