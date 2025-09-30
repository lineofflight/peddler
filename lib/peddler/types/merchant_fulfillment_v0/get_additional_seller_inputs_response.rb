# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/merchant_fulfillment_v0/get_additional_seller_inputs_result"
require "peddler/types/merchant_fulfillment_v0/error"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # Response schema.
      GetAdditionalSellerInputsResponse = Structure.new do
        # @return [GetAdditionalSellerInputsResult]
        attribute?(:payload, GetAdditionalSellerInputsResult)

        # @return [Array<Error>]
        attribute?(:errors, [Error])
      end
    end
  end
end
