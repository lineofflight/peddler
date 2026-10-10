# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module SellerWallet20240301
      # The balance amount in the Amazon Seller Wallet bank account.
      Balance = Structure.new do
        # The unique identifier provided by Amazon to identify the account.
        attribute(:account_id, String, null: false, from: "accountId")

        # The balance amount in number format.
        attribute(:balance_amount, Float, null: false, from: "balanceAmount")

        # The Amazon Seller Wallet bank account currency code in ISO 4217 format.
        attribute(:balance_currency, String, null: false, from: "balanceCurrency")

        # The date of the most recent account balance update.
        attribute(:last_update_date, Time, null: false, from: "lastUpdateDate")

        # The type of balance.
        attribute?(:balance_type, String, from: "balanceType")
      end
    end
  end
end
