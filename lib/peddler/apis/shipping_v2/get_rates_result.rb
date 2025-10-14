# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
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
