# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SellerWallet20240301
      # The fees and foreign exchange rates that apply to the transaction.
      #
      # If the fees are in terms of the `baseAmount` (source account) currency, then the effective rate is equal to **1
      # - (fees * `baseRate` / `baseAmount`)**.
      #
      # If the fees are in terms of the `transferAmount` (destination account) currency, then the effective rate is
      # equal to **`baseRate` - (fees / `baseAmount`)**.
      #
      # In the preceding expressions, **fees** is equal to the sum of all `feeAmount.currencyAmount` values in the
      # `fees` array.
      TransferRatePreview = Structure.new do
        # @return [Money] Base amount of the transaction.
        attribute(:base_amount, Money, null: false, from: "baseAmount")

        # @return [Array<Fee>] List of fees
        attribute(:fees, [Fee], null: false)

        # @return [FxRateDetails] The foreign exchange rate value of the transaction.
        attribute(:fx_rate_details, FxRateDetails, null: false, from: "fxRateDetails")

        # @return [Money] The final amount reflects both the fee deduction and currency conversion rate exchange
        attribute(:transfer_amount, Money, null: false, from: "transferAmount")
      end
    end
  end
end
