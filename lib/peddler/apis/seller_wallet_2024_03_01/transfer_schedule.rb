# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SellerWallet20240301
      # Transfer schedule details and related historical details.
      TransferSchedule = Structure.new do
        # @return [TransactionAccount] Details of the destination bank account in the scheduled transfer. Here
        #   `bankAccountCountryCode` is a required field.
        attribute(:transaction_destination_account, TransactionAccount, null: false, from: "transactionDestinationAccount")

        # @return [String] The type of transfer.
        attribute(:transaction_type, String, null: false, from: "transactionType")

        # @return [Array<TransferScheduleFailures>] A list of transfer schedule failures.
        attribute(:transfer_schedule_failures, [TransferScheduleFailures], null: false, from: "transferScheduleFailures")

        # @return [String] The unique identifier provided by Amazon to the scheduled transfer.
        attribute(:transfer_schedule_id, String, null: false, from: "transferScheduleId")

        # @return [TransferScheduleInformation] The fields required for the scheduled transfer. This information can be
        #   modified when you update a transfer schedule.
        attribute(:transfer_schedule_information, TransferScheduleInformation, null: false, from: "transferScheduleInformation")

        # @return [String] The type of transfer schedule. This information can be modified when you update a transfer
        #   schedule.
        attribute(:transfer_schedule_status, String, null: false, from: "transferScheduleStatus")

        # @return [PaymentPreference] The payment preference of the scheduled transfer. This information can be modified
        #   when you update a transfer schedule.
        attribute?(:payment_preference, PaymentPreference, from: "paymentPreference")

        # @return [TransactionAccount] Details of the source bank account in the scheduled transfer.
        attribute?(:transaction_source_account, TransactionAccount, from: "transactionSourceAccount")
      end
    end
  end
end
