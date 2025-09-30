# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/seller_wallet_2024_03_01/transaction_account"
require "peddler/types/seller_wallet_2024_03_01/transfer_schedule_information"
require "peddler/types/seller_wallet_2024_03_01/payment_preference"
require "peddler/types/seller_wallet_2024_03_01/transfer_schedule_failures"

module Peddler
  module Types
    module SellerWallet20240301
      # Transfer schedule details and related historical details.
      TransferSchedule = Structure.new do
        # @return [String] The unique identifier provided by Amazon to the scheduled transfer
        attribute(:transfer_schedule_id, String, from: "transferScheduleId")

        # @return [String] Type of the transfer
        attribute(:transaction_type, String, from: "transactionType")

        # @return [TransactionAccount] Source bank account details in the scheduled transfer
        attribute?(:transaction_source_account, TransactionAccount, from: "transactionSourceAccount")

        # @return [TransactionAccount] Destination bank account details in the scheduled transfer. Here
        # bankAccountCountryCode is a MANDATORY field
        attribute(:transaction_destination_account, TransactionAccount, from: "transactionDestinationAccount")

        # @return [String] Type of the transfer schedule. This information can be modified when updating a transfer
        # schedule.
        attribute(:transfer_schedule_status, String, from: "transferScheduleStatus")

        # @return [TransferScheduleInformation] Fields required for the scheduled transfer. This information can be
        # modified when updating a transfer schedule.
        attribute(:transfer_schedule_information, TransferScheduleInformation, from: "transferScheduleInformation")

        # @return [PaymentPreference] Payment preference of the scheduled transfer. This information can be modified
        # when updating a transfer schedule.
        attribute?(:payment_preference, PaymentPreference, from: "paymentPreference")

        # @return [Array<TransferScheduleFailures>] Collection that holds Transfer Schedules that has been cancelled or
        # failed due to certain reasons.
        attribute(:transfer_schedule_failures, [TransferScheduleFailures], from: "transferScheduleFailures")
      end
    end
  end
end
