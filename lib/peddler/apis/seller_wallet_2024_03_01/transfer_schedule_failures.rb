# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module SellerWallet20240301
      # The time of and reason for the transfer schedule failure.
      TransferScheduleFailures = Structure.new do
        # The transfer schedule failure date.
        attribute(:transfer_schedule_failure_date, Time, null: false, from: "transferScheduleFailureDate")

        # The reason listed for the failure of the transfer schedule.
        attribute(:transfer_schedule_failure_reason, String, null: false, from: "transferScheduleFailureReason")
      end
    end
  end
end
