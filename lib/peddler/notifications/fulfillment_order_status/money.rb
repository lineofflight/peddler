# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FulfillmentOrderStatus
      # An amount of money, including units in the form of currency.
      Money = Structure.new do
        # @return [String]
        attribute(:amount, String, null: false)

        # @return [String] Three digit currency code in ISO 4217 format.
        attribute(:currency_code, String, null: false, from: "currencyCode")
      end
    end
  end
end
