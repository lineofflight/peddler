# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Promotions20251201
      # The discount configuration shared across benefit types.
      Discount = Structure.new do
        # The method used to calculate the discount amount. Known values: `PERCENTAGE_OFF`, `AMOUNT_OFF`, `FREE_ITEM`.
        attribute(:type, String, null: false)

        # The amount off value. Only valid when `type` is `AMOUNT_OFF`.
        attribute?(:amount_off, Float, from: "amountOff")

        # The currency code in ISO 4217 format. Required when `type` is `AMOUNT_OFF`.
        attribute?(:currency_code, String, from: "currencyCode")

        # The percentage discount value (1-100). Only valid when `type` is `PERCENTAGE_OFF`.
        attribute?(:percent_off, Float, from: "percentOff")
      end
    end
  end
end
