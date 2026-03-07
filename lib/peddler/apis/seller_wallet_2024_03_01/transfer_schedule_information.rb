# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class SellerWallet20240301
      # Mandatory information for initiating a schedule transfer.
      TransferScheduleInformation = Structure.new do
        # @return [Time] The end date of the scheduled transfer.
        attribute?(:schedule_end_date, Time, from: "scheduleEndDate")

        # @return [ScheduleExpression] How often the scheduled transfer repeats.
        attribute?(:schedule_expression, ScheduleExpression, from: "scheduleExpression")

        # @return [Time] The start date of the scheduled transfer.
        attribute?(:schedule_start_date, Time, from: "scheduleStartDate")

        # @return [String] The type of schedule.
        attribute?(:schedule_type, String, from: "scheduleType")
      end
    end
  end
end
