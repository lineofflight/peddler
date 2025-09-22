# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "peddler/types/seller_wallet_2024_03_01/fx_rate_details"
require "peddler/types/seller_wallet_2024_03_01/fee"

module Peddler
  module Types
    module SellerWallet20240301
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
        attribute(:base_amount, Money, from: "baseAmount")

        # @return [FxRateDetails] The foreign exchange rate value of the transaction.
        attribute(:fx_rate_details, FxRateDetails, from: "fxRateDetails")

        # @return [Money] The final amount reflects both the fee deduction and currency conversion rate exchange
        attribute(:transfer_amount, Money, from: "transferAmount")

        # @return [Array<Fee>] List of fees
        attribute(:fees, [Fee])
      end
    end
  end
end
