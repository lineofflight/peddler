# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Promotions20251201
      # Budget configuration for spending limits. For `COUPON` and `BASKET_BUILDING` promotion types, the budget is set
      # at the promotion level and applies to the entire promotion. For `DEAL` and `PRICE_DISCOUNT` promotion types, the
      # budget is set at the item level within each item in the selection.
      Budget = Structure.new do
        # @return [String] The budget type, either monetary or unit-based.
        attribute(:type, String, null: false)

        # @return [Float] Budget value (amount or unit count).
        attribute(:value, Float, null: false)

        # @return [String] The currency code in ISO 4217 format. Required when `type` is `AMOUNT`.
        attribute?(:currency_code, String, from: "currencyCode")
      end
    end
  end
end
