# frozen_string_literal: true

require "peddler/types/merchant_fulfillment_v0/get_eligible_shipment_services_result"
require "peddler/types/merchant_fulfillment_v0/error"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # Response schema.
      GetEligibleShipmentServicesResponse = Structure.new do
        # @return [GetEligibleShipmentServicesResult]
        attribute(:payload, GetEligibleShipmentServicesResult)

        # @return [Array<Error>] One or more unexpected errors occurred during this operation.
        attribute(:errors, [Error])
      end
    end
  end
end
