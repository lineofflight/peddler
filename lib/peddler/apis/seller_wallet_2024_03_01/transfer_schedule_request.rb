# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SellerWallet20240301
      # Request body to initiate a scheduled transfer from a SW bank account to another customer defined bank account
      TransferScheduleRequest = Structure.new do
        # @return [String] Optional field to specify the unique identifier of the destination bank account where the
        #   money needs to be deposited
        attribute(:destination_account_id, String, from: "destinationAccountId")

        # @return [TransactionInstrumentDetails] Destination bank account details of the transaction request
        attribute(:destination_transaction_instrument, TransactionInstrumentDetails, from: "destinationTransactionInstrument")

        # @return [PaymentPreference] Payment preference of the scheduled transfer
        attribute(:payment_preference, PaymentPreference, from: "paymentPreference")

        # @return [String] The unique identifier of the source Amazon SW bank account from where the money needs to be
        #   debited
        attribute(:source_account_id, String, from: "sourceAccountId")

        # @return [String] Represents 3 letter currency code in ISO 4217 standard format of the source payment method
        #   country
        attribute(:source_currency_code, String, from: "sourceCurrencyCode")

        # @return [String] Type of the scheduled transaction
        attribute(:transaction_type, String, from: "transactionType")

        # @return [TransferScheduleInformation] Fields required for the scheduled transfer
        attribute(:transfer_schedule_information, TransferScheduleInformation, from: "transferScheduleInformation")

        # @return [String] Type of the transaction schedule which is mandatory field in request body if a transfer
        #   schedule needs to be updated
        attribute?(:transfer_schedule_status, String, from: "transferScheduleStatus")
      end
    end
  end
end
