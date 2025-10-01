# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/merchant_fulfillment_v0/error"
require "peddler/types/merchant_fulfillment_v0/get_additional_seller_inputs_result"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # Response schema.
      GetAdditionalSellerInputsResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [GetAdditionalSellerInputsResult]
        attribute?(:payload, GetAdditionalSellerInputsResult)
      end
    end
  end
end
