# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SellerWallet20240301
      # Foreign exchange rate details.
      FxRateDetails = Structure.new do
        # The market foreign exchange rate.
        attribute(:base_rate, Float, null: false, from: "baseRate")

        # The total rate applied to the money transfer. This includes all exchange rates, markups, and fees.
        attribute(:effective_fx_rate, Float, null: false, from: "effectiveFxRate")

        # The unique identifier assigned to the fees / foreign exchange rate of a transaction.
        attribute(:fx_rate_id, String, null: false, from: "fxRateId")

        # Whether the customer is buying or selling the source currency. Known values: `BUY`, `SELL`.
        attribute(:rate_direction, String, null: false, from: "rateDirection")
      end
    end
  end
end
