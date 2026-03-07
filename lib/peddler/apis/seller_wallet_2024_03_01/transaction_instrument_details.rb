# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SellerWallet20240301
      # Details of the destination bank account in the transaction request.
      TransactionInstrumentDetails = Structure.new do
        # @return [String] The bank account holder's name (expected to be an Amazon customer).
        #
        # **Note:** This field is encrypted before Amazon receives it, so should not be used to generate
        #   `destAccountDigitalSignature`, and should not be included in the request signature.
        attribute(:account_holder_name, String, null: false, from: "accountHolderName")

        # @return [BankAccount] Details of the destination bank account.
        attribute(:bank_account, BankAccount, null: false, from: "bankAccount")

        # @return [String] The bank account number of the destination payment method.
        #
        # **Note:** This field is encrypted before Amazon receives it, so should not be used to generate
        #   `destAccountDigitalSignature`, and should not be included in the request signature.
        attribute(:bank_account_number, String, null: false, from: "bankAccountNumber")
      end
    end
  end
end
