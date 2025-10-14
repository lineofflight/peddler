# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # The response schema for the getRates operation.
      GetRatesResponse = Structure.new do
        # @return [GetRatesResult]
        attribute?(:payload, GetRatesResult)
      end
    end
  end
end
