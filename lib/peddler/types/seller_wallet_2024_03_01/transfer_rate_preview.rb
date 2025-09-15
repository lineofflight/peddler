# frozen_string_literal: true

require "peddler/types/seller_wallet_2024_03_01/currency"
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
        # @return [Currency] Base amount of the transaction.
        attribute(:base_amount, Currency, from: "baseAmount")

        # @return [FxRateDetails] The foreign exchange rate value of the transaction.
        attribute(:fx_rate_details, FxRateDetails, from: "fxRateDetails")

        # @return [Currency] The final amount reflects both the fee deduction and currency conversion rate exchange
        attribute(:transfer_amount, Currency, from: "transferAmount")

        # @return [Array<Fee>] List of fees
        attribute(:fees, [Fee])
      end
    end
  end
end
