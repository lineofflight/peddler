# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
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
