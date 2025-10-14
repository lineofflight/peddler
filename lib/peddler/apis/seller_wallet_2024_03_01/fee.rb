# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SellerWallet20240301
      # If the fees is in baseAmount (sourceAccount) currency, effectiveRate = (baseAmount -
      # sum(fees.feeAmount.currencyAmount)) * baseRate) / baseAmount. If the fees is in transferAmount
      # (destinationAccount) currency, effectiveRate = (( baseAmount * baseRate ) - sum(fees.feeAmount.currencyAmount ))
      # / baseAmount
      Fee = Structure.new do
        # @return [Money] Displays actual value of the fee in numeric format.
        attribute(:fee_amount, Money, from: "feeAmount")

        # @return [String] Unique identifier assigned to the Fee.
        attribute(:fee_id, String, from: "feeId")

        # @return [String] The value of the fee in percentage format.
        attribute(:fee_rate_value, String, from: "feeRateValue")

        # @return [String] Displays type of the Fee.
        attribute(:fee_type, String, from: "feeType")
      end
    end
  end
end
