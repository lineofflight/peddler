# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class SellerWallet20240301
      # Specifies the balance amount in the Amazon SW bank account
      Balance = Structure.new do
        # @return [String] The unique identifier provided by Amazon to identify the account
        attribute(:account_id, String, null: false, from: "accountId")

        # @return [Float] The balance amount in number format
        attribute(:balance_amount, Float, null: false, from: "balanceAmount")

        # @return [String] The Amazon SW bank account currency code in ISO 4217 format
        attribute(:balance_currency, String, null: false, from: "balanceCurrency")

        # @return [Time] The last update date on the account balance
        attribute(:last_update_date, Time, null: false, from: "lastUpdateDate")

        # @return [String] Type of the balance
        attribute?(:balance_type, String, from: "balanceType")
      end
    end
  end
end
