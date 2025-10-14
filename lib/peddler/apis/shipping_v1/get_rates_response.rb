# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV1
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
