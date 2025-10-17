# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class SellerWallet20240301
      # Parameters containing information required for initiating a schedule transfer
      TransferScheduleInformation = Structure.new do
        # @return [Time] Field to specify end date of the scheduled transfer
        attribute?(:schedule_end_date, Time, from: "scheduleEndDate")

        # @return [ScheduleExpression] Field to specify expression for how often the schedule transfer repeats. Refer to
        #   this documentation: https://docs.aws.amazon.com/scheduler/latest/APIReference/API_CreateSchedule.html
        attribute?(:schedule_expression, ScheduleExpression, from: "scheduleExpression")

        # @return [Time] Field to specify start date of the scheduled transfer
        attribute?(:schedule_start_date, Time, from: "scheduleStartDate")

        # @return [String] Field to specify type of the transfer being scheduled
        attribute?(:schedule_type, String, from: "scheduleType")
      end
    end
  end
end
