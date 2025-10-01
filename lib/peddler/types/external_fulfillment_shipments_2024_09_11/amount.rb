# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
      # An amount of money, including units in the form of currency.
      Amount = Structure.new do
        # @return [String] Three digit currency code in ISO 4217 format.
        attribute(:currency_code, String, from: "currencyCode")

        # @return [String] The amount of money.
        attribute(:value, String)
      end
    end
  end
end
