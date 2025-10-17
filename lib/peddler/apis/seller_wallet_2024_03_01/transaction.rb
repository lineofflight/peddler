# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class SellerWallet20240301
      # The current transaction status and related historical details.
      Transaction = Structure.new do
        # @return [Time] The last update date on the transaction
        attribute(:last_update_date, Time, from: "lastUpdateDate")

        # @return [String] A description of the transaction that the requester provides when they initiate the
        #   transaction.
        attribute(:transaction_description, String, from: "transactionDescription")

        # @return [TransactionAccount] Destination bank account details in the transaction
        attribute(:transaction_destination_account, TransactionAccount, from: "transactionDestinationAccount")

        # @return [String] The unique identifier provided by Amazon to the transaction
        attribute(:transaction_id, String, from: "transactionId")

        # @return [Money] Specifies the amount for which the transfer was initiated
        attribute(:transaction_request_amount, Money, from: "transactionRequestAmount")

        # @return [Time] The date when the transaction was initiated.
        attribute(:transaction_request_date, Time, from: "transactionRequestDate")

        # @return [String] The transaction initiation source. This value is either the Amazon portal or PISP name that
        #   the customer used to start the transaction.
        attribute(:transaction_requester_source, String, from: "transactionRequesterSource")

        # @return [TransactionAccount] Source bank account details in the transaction
        attribute(:transaction_source_account, TransactionAccount, from: "transactionSourceAccount")

        # @return [String] Execution Status of the transaction
        attribute(:transaction_status, String, from: "transactionStatus")

        # @return [String] Type of the transaction
        attribute(:transaction_type, String, from: "transactionType")

        # @return [TransferRatePreview] The fees and rates that apply to the transaction, as applicable.
        attribute(:transfer_rate_details, TransferRatePreview, from: "transferRateDetails")

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
      end
    end
  end
end
