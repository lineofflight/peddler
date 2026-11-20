# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # An amount of money, including units in the form of currency.
      Amount = Structure.new do
        # Three digit currency code in ISO 4217 format.
        attribute(:currency_code, String, null: false, from: "currencyCode")

        # The amount of money.
        attribute(:value, Float, null: false)
      end
    end
  end
end
