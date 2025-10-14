# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
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
