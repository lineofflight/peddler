# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module SellerWallet20240301
      # The current transaction status and related historical details.
      Transaction = Structure.new do
        # The unique identifier of the Amazon Seller Wallet bank account from which the money is debited.
        attribute(:account_id, String, null: false, from: "accountId")

        # The date of the most recent account balance update.
        attribute(:last_update_date, Time, null: false, from: "lastUpdateDate")

        # A description of the transaction that the requester provides when they initiate the transaction.
        attribute(:transaction_description, String, null: false, from: "transactionDescription")

        # The destination bank account details in the transaction.
        attribute(:transaction_destination_account, TransactionAccount, null: false, from: "transactionDestinationAccount")

        # The unique identifier provided by Amazon to the transaction.
        attribute(:transaction_id, String, null: false, from: "transactionId")

        # The amount for which the transfer was initiated.
        attribute(:transaction_request_amount, Money, null: false, from: "transactionRequestAmount")

        # The date when the transaction was initiated.
        attribute(:transaction_request_date, Time, null: false, from: "transactionRequestDate")

        # The transaction initiation source. This value is either the Amazon portal or PISP name that the customer used
        # to start the transaction.
        attribute(:transaction_requester_source, String, null: false, from: "transactionRequesterSource")

        # The status of the transaction. Known values: `EXPIRED`, `FAILED`, `FAILED_CREDITS_APPLIED`, `IN_PROGRESS`,
        # `PENDING_USER_APPROVAL`, `SUCCESSFUL`.
        attribute(:transaction_status, String, null: false, from: "transactionStatus")

        # The type of the transaction. Known values: `CREDIT`, `DEBIT`.
        attribute(:transaction_type, String, null: false, from: "transactionType")

        # The fees and rates that apply to the transaction, as applicable.
        attribute(:transfer_rate_details, TransferRatePreview, null: false, from: "transferRateDetails")

        # The expected completion date of the transaction.
        attribute?(:expected_completion_date, Time, from: "expectedCompletionDate")

        # The Amazon Seller Wallet customer who requested the transaction.
        attribute?(:requester_name, String, from: "requesterName")

        # The transaction's completion date.
        attribute?(:transaction_actual_completion_date, Time, from: "transactionActualCompletionDate")

        # The reason the transaction failed, if applicable.
        attribute?(:transaction_failure_reason, String, from: "transactionFailureReason")

        # The amount of completed transaction in the destination account currency. This value is only populated for
        # international transactions
        attribute?(:transaction_final_amount, Money, from: "transactionFinalAmount")

        # The source bank account details in the transaction.
        attribute?(:transaction_source_account, TransactionAccount, from: "transactionSourceAccount")
      end
    end
  end
end
