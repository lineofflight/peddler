# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ProductPricing20220501
      # Currency type and monetary value schema to demonstrate pricing information.
      MoneyType = Structure.new do
        # @return [String] The currency code in ISO 4217 format.
        attribute(:currency_code, String, from: "currencyCode")

        # @return [Float] The monetary value.
        attribute(:amount, Float)
      end
    end
  end
end
