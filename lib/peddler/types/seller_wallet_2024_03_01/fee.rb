# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/seller_wallet_2024_03_01/currency"

module Peddler
  module Types
    module SellerWallet20240301
      # If the fees is in baseAmount (sourceAccount) currency, effectiveRate = (baseAmount -
      # sum(fees.feeAmount.currencyAmount)) * baseRate) / baseAmount. If the fees is in transferAmount
      # (destinationAccount) currency, effectiveRate = (( baseAmount * baseRate ) - sum(fees.feeAmount.currencyAmount ))
      # / baseAmount
      Fee = Structure.new do
        # @return [String] Unique identifier assigned to the Fee.
        attribute(:fee_id, String, from: "feeId")

        # @return [String] Displays type of the Fee.
        attribute(:fee_type, String, from: "feeType")

        # @return [String] The value of the fee in percentage format.
        attribute(:fee_rate_value, String, from: "feeRateValue")

        # @return [Currency] Displays actual value of the fee in numeric format.
        attribute(:fee_amount, Currency, from: "feeAmount")
      end
    end
  end
end
