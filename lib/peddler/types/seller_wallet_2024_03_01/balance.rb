# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module SellerWallet20240301
      # Specifies the balance amount in the Amazon SW bank account
      Balance = Structure.new do
        # @return [String] The unique identifier provided by Amazon to identify the account
        attribute(:account_id, String, from: "accountId")

        # @return [String] Type of the balance
        attribute(:balance_type, String, from: "balanceType")

        # @return [Float] The balance amount in number format
        attribute(:balance_amount, Float, from: "balanceAmount")

        # @return [String] The Amazon SW bank account currency code in ISO 4217 format
        attribute(:balance_currency, String, from: "balanceCurrency")

        # @return [String] The last update date on the account balance
        attribute(:last_update_date, String, from: "lastUpdateDate")
      end
    end
  end
end
