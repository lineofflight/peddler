# frozen_string_literal: true

require "peddler/types/shipping_v1/get_rates_result"
require "peddler/types/shipping_v1/error"

module Peddler
  module Types
    module ShippingV1
      # The response schema for the getRates operation.
      GetRatesResponse = Structure.new do
        # @return [GetRatesResult] The payload for getRates operation
        attribute(:payload, GetRatesResult)

        # @return [Array<Error>] Encountered errors for the operation.
        attribute(:errors, [Error])
      end
    end
  end
end
