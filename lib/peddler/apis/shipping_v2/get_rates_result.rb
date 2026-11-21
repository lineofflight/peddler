# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # The payload for the getRates operation.
      GetRatesResult = Structure.new do
        attribute(:rates, [Rate], null: false)

        attribute(:request_token, String, null: false, from: "requestToken")

        attribute?(:ineligible_rates, [IneligibleRate], from: "ineligibleRates")
      end
    end
  end
end
