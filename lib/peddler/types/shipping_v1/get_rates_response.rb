# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v1/error"
require "peddler/types/shipping_v1/get_rates_result"

module Peddler
  module Types
    module ShippingV1
      # The response schema for the getRates operation.
      GetRatesResponse = Structure.new do
        # @return [Array<Error>] Encountered errors for the operation.
        attribute?(:errors, [Error])

        # @return [GetRatesResult] The payload for getRates operation
        attribute?(:payload, GetRatesResult)
      end
    end
  end
end
