# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Promotions20251201
      # The discount configuration shared across benefit types.
      Discount = Structure.new do
        # @return [String] The method used to calculate the discount amount.
        attribute(:type, String, null: false)

        # @return [Float] The amount off value. Only valid when `type` is `AMOUNT_OFF`.
        attribute?(:amount_off, Float, from: "amountOff")

        # @return [String] The currency code in ISO 4217 format. Required when `type` is `AMOUNT_OFF`.
        attribute?(:currency_code, String, from: "currencyCode")

        # @return [Float] The percentage discount value (1-100). Only valid when `type` is `PERCENTAGE_OFF`.
        attribute?(:percent_off, Float, from: "percentOff")
      end
    end
  end
end
