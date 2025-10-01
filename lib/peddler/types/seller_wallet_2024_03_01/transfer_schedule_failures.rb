# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module SellerWallet20240301
      # Specifies the balance amount in the Amazon SW bank account
      TransferScheduleFailures = Structure.new do
        # @return [String] The transfer schedule cancellation date
        attribute(:transfer_schedule_failure_date, String, from: "transferScheduleFailureDate")

        # @return [String] The statement/reasoning listed for the cancellation of the transfer schedule
        attribute(:transfer_schedule_failure_reason, String, from: "transferScheduleFailureReason")
      end
    end
  end
end
