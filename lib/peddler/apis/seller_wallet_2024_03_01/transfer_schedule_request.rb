# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SellerWallet20240301
      # Request body to initiate a scheduled transfer from a Seller Wallet bank account to another customer-defined bank
      # account.
      TransferScheduleRequest = Structure.new do
        # @return [String] The unique identifier of the destination bank account where the money is deposited.
        attribute(:destination_account_id, String, null: false, from: "destinationAccountId")

        # @return [TransactionInstrumentDetails] Details of the destination bank account in the transaction request.
        attribute(:destination_transaction_instrument, TransactionInstrumentDetails, null: false, from: "destinationTransactionInstrument")

        # @return [PaymentPreference] The payment preference of the scheduled transfer.
        attribute(:payment_preference, PaymentPreference, null: false, from: "paymentPreference")

        # @return [String] The unique identifier of the source Amazon Seller Wallet bank account from which money is
        #   debited.
        attribute(:source_account_id, String, null: false, from: "sourceAccountId")

        # @return [String] The three-letter currency code of the source payment method country, in ISO 4217 format.
        attribute(:source_currency_code, String, null: false, from: "sourceCurrencyCode")

        # @return [String] The type of the scheduled transaction.
        attribute(:transaction_type, String, null: false, from: "transactionType")

        # @return [TransferScheduleInformation] The configuration of the scheduled transfer.
        attribute(:transfer_schedule_information, TransferScheduleInformation, null: false, from: "transferScheduleInformation")

        # @return [String] The type of transaction schedule. This field is required when you update a transfer schedule.
        attribute?(:transfer_schedule_status, String, from: "transferScheduleStatus")
      end
    end
  end
end
