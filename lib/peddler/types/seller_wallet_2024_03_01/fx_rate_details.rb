# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module SellerWallet20240301
      # Foreign exchange rate details displayed when transfer preview is requested.
      FxRateDetails = Structure.new do
        # @return [String] Unique identifier assigned to the fees/foreign exchange Rate of a transaction.
        attribute(:fx_rate_id, String, from: "fxRateId")

        # @return [Float] This is the rate that will be market foreign exchange rate. For example: 1USD -> 86.0 INR.
        attribute(:base_rate, Float, from: "baseRate")

        # @return [Float] Displays the foreign exchange rate which will be all rates and fees baked in (i.e; markup
        # fees), example: market fx rate and international transaction fee.
        attribute(:effective_fx_rate, Float, from: "effectiveFxRate")

        # @return [String] Rate Direction can refer to the way final amount is calculated.
        attribute(:rate_direction, String, from: "rateDirection")
      end
    end
  end
end
