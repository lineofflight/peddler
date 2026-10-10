# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MerchantFulfillmentV0
      # Response schema.
      GetAdditionalSellerInputsResponse = Structure.new do
        attribute?(:errors, [Error])

        attribute?(:payload, GetAdditionalSellerInputsResult)
      end
    end
  end
end
