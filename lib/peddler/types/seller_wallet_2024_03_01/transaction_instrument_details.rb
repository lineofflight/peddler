# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/seller_wallet_2024_03_01/bank_account"

module Peddler
  module Types
    module SellerWallet20240301
      # Request body to create transaction instrument, Amazon performs validation and screening (anti-money laundering
      # measuers) on all the transaction instruments before executing a transaction thus it requires transaction
      # instrument holder's contact details as well
      TransactionInstrumentDetails = Structure.new do
        # @return [String] The bank account holder's name (expected to be an Amazon customer).
        #
        # **Note:** This field is encrypted before Amazon receives it, so should not be used to generate
        # `destAccountDigitalSignature`, and should not be included in the request signature.
        attribute(:account_holder_name, String, from: "accountHolderName")

        # @return [BankAccount] Specifies the destination bank account details where the money needs to be deposited
        attribute(:bank_account, BankAccount, from: "bankAccount")

        # @return [String] This field would be used to populate the bank account number of the destination payment
        # method. The field is intentionally not included in any other Schemas since Amazon internal systems will never
        # receive it in unencrypted format, so field won't be part of the request signature
        attribute(:bank_account_number, String, from: "bankAccountNumber")
      end
    end
  end
end
