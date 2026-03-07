# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SellerWallet20240301
      # Foreign exchange rate details.
      FxRateDetails = Structure.new do
        # @return [Float] The market foreign exchange rate.
        attribute(:base_rate, Float, null: false, from: "baseRate")

        # @return [Float] The total rate applied to the money transfer. This includes all exchange rates, markups, and
        #   fees.
        attribute(:effective_fx_rate, Float, null: false, from: "effectiveFxRate")

        # @return [String] The unique identifier assigned to the fees / foreign exchange rate of a transaction.
        attribute(:fx_rate_id, String, null: false, from: "fxRateId")

        # @return [String] Whether the customer is buying or selling the source currency.
        attribute(:rate_direction, String, null: false, from: "rateDirection")
      end
    end
  end
end
