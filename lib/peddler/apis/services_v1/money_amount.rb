# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ServicesV1
      # The monetary amount and type of currency.
      MoneyAmount = Structure.new do
        # @return [String] The currency code in ISO 4217 format.
        attribute(:currency, String, null: false)

        # @return [Float] The monetary value.
        attribute(:value, Float, null: false)
      end
    end
  end
end
