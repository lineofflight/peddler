# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class SellerWallet20240301
      # The current transaction status and related historical details.
      Transaction = Structure.new do
        # @return [String] The unique identifier of the Amazon Seller Wallet bank account from which the money is
        #   debited.
        attribute(:account_id, String, null: false, from: "accountId")

        # @return [Time] The last update date on the transaction
        attribute(:last_update_date, Time, null: false, from: "lastUpdateDate")

        # @return [String] A description of the transaction that the requester provides when they initiate the
        #   transaction.
        attribute(:transaction_description, String, null: false, from: "transactionDescription")

        # @return [TransactionAccount] Destination bank account details in the transaction
        attribute(:transaction_destination_account, TransactionAccount, null: false, from: "transactionDestinationAccount")

        # @return [String] The unique identifier provided by Amazon to the transaction
        attribute(:transaction_id, String, null: false, from: "transactionId")

        # @return [Money] Specifies the amount for which the transfer was initiated
        attribute(:transaction_request_amount, Money, null: false, from: "transactionRequestAmount")

        # @return [Time] The date when the transaction was initiated.
        attribute(:transaction_request_date, Time, null: false, from: "transactionRequestDate")

        # @return [String] The transaction initiation source. This value is either the Amazon portal or PISP name that
        #   the customer used to start the transaction.
        attribute(:transaction_requester_source, String, null: false, from: "transactionRequesterSource")

        # @return [String] Execution Status of the transaction
        attribute(:transaction_status, String, null: false, from: "transactionStatus")

        # @return [String] Type of the transaction
        attribute(:transaction_type, String, null: false, from: "transactionType")

        # @return [TransferRatePreview] The fees and rates that apply to the transaction, as applicable.
        attribute(:transfer_rate_details, TransferRatePreview, null: false, from: "transferRateDetails")

        # @return [Time] Expected completion date of a transaction, for existing active Payees (Trusted Beneficiaries)
        #   it will be 24 hours but for new destination bank accounts the value could go up to 5 days
        attribute?(:expected_completion_date, Time, from: "expectedCompletionDate")

        # @return [String] Amazon SW customer who requested the transaction
        attribute?(:requester_name, String, from: "requesterName")

        # @return [Time] Transaction completion date
        attribute?(:transaction_actual_completion_date, Time, from: "transactionActualCompletionDate")

        # @return [String] Description in case the transaction fails before completion
        attribute?(:transaction_failure_reason, String, from: "transactionFailureReason")

        # @return [Money] Specifies the amount of completed transaction in the destination account currency, this will
        #   be populated only for international transactions
        attribute?(:transaction_final_amount, Money, from: "transactionFinalAmount")

        # @return [TransactionAccount] Source bank account details in the transaction
        attribute?(:transaction_source_account, TransactionAccount, from: "transactionSourceAccount")
      end
    end
  end
end
