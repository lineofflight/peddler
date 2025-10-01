# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/merchant_fulfillment_v0/error"
require "peddler/types/merchant_fulfillment_v0/get_eligible_shipment_services_result"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # Response schema.
      GetEligibleShipmentServicesResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during this operation.
        attribute?(:errors, [Error])

        # @return [GetEligibleShipmentServicesResult]
        attribute?(:payload, GetEligibleShipmentServicesResult)
      end
    end
  end
end
