# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ProductFeesV0
      # An object representing a monetary value with its currency information.
      MoneyType = Structure.new do
        # @return [String] The currency code in ISO 4217 format.
        attribute(:currency_code, String, from: "CurrencyCode")

        # @return [Float] The monetary value.
        attribute(:amount, Float, from: "Amount")
      end
    end
  end
end
