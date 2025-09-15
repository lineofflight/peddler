# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # Currency type and amount.
      CurrencyAmount = Structure.new do
        # @return [String] Three-digit currency code in ISO 4217 format.
        attribute(:currency_code, String, from: "CurrencyCode")

        # @return [Float] The currency amount.
        attribute(:amount, Float, from: "Amount")
      end
    end
  end
end
