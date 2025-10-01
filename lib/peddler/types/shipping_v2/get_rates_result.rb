# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v2/rate"
require "peddler/types/shipping_v2/ineligible_rate"

module Peddler
  module Types
    module ShippingV2
      # The payload for the getRates operation.
      GetRatesResult = Structure.new do
        # @return [Array<Rate>]
        attribute(:rates, [Rate])

        # @return [String]
        attribute(:request_token, String, from: "requestToken")

        # @return [Array<IneligibleRate>]
        attribute?(:ineligible_rates, [IneligibleRate], from: "ineligibleRates")
      end
    end
  end
end
