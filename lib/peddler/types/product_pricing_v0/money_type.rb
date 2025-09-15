# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ProductPricingV0
      # Currency type and monetary value. Schema for demonstrating pricing info.
      MoneyType = Structure.new do
        # @return [String] The currency code in ISO 4217 format.
        attribute(:currency_code, String, from: "CurrencyCode")

        # @return [Float] The monetary value.
        attribute(:amount, Float, from: "Amount")
      end
    end
  end
end
