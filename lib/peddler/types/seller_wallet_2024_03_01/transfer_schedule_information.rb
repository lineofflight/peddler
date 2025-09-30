# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/seller_wallet_2024_03_01/schedule_expression"

module Peddler
  module Types
    module SellerWallet20240301
      # Parameters containing information required for initiating a schedule transfer
      TransferScheduleInformation = Structure.new do
        # @return [String] Field to specify start date of the scheduled transfer
        attribute?(:schedule_start_date, String, from: "scheduleStartDate")

        # @return [String] Field to specify end date of the scheduled transfer
        attribute?(:schedule_end_date, String, from: "scheduleEndDate")

        # @return [ScheduleExpression] Field to specify expression for how often the schedule transfer repeats. Refer to
        # this documentation: https://docs.aws.amazon.com/scheduler/latest/APIReference/API_CreateSchedule.html
        attribute?(:schedule_expression, ScheduleExpression, from: "scheduleExpression")

        # @return [String] Field to specify type of the transfer being scheduled
        attribute?(:schedule_type, String, from: "scheduleType")
      end
    end
  end
end
