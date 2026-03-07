# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SellerWallet20240301
      # Details of the bank account involved in the transaction.
      TransactionAccount = Structure.new do
        # @return [String] The currency code in ISO 4217 format.
        attribute(:bank_account_currency, String, null: false, from: "bankAccountCurrency")

        # @return [String] The format for the bank account number.
        attribute(:bank_account_number_format, String, null: false, from: "bankAccountNumberFormat")

        # @return [String] The name of the bank.
        attribute(:bank_name, String, null: false, from: "bankName")

        # @return [String] The unique identifier provided by Amazon to identify the account.
        attribute?(:account_id, String, from: "accountId")

        # @return [String] The two-digit country code, in ISO 3166 format. This field is optional for
        #   `transactionSourceAccount`, but is mandatory for `transactionDestinationAccount`.
        attribute?(:bank_account_country_code, String, from: "bankAccountCountryCode")

        # @return [String] The account holder's name.
        attribute?(:bank_account_holder_name, String, from: "bankAccountHolderName")

        # @return [String] The last three digits of the bank account number.
        attribute?(:bank_account_number_tail, String, from: "bankAccountNumberTail")
      end
    end
  end
end
