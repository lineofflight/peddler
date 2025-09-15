# frozen_string_literal: true

require "peddler/types/shipping_v2/get_rates_result"

module Peddler
  module Types
    module ShippingV2
      # The response schema for the getRates operation.
      GetRatesResponse = Structure.new do
        # @return [GetRatesResult]
        attribute(:payload, GetRatesResult)
      end
    end
  end
end
