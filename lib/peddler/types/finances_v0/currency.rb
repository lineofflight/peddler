# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module FinancesV0
      # A currency type and amount.
      Currency = Structure.new do
        # @return [String] The three-digit currency code in ISO 4217 format.
        attribute(:currency_code, String, from: "CurrencyCode")

        # @return [Float] The monetary value.
        attribute(:currency_amount, Float, from: "CurrencyAmount")
      end
    end
  end
end
