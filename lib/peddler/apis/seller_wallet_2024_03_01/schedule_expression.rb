# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SellerWallet20240301
      # The configuration of the schedule.
      ScheduleExpression = Structure.new do
        # @return [String] The type of the scheduled transfer.
        attribute(:schedule_expression_type, String, null: false, from: "scheduleExpressionType")

        # @return [String] How often the scheduled transfer happens. This field is required if `scheduleExpressionType`
        #   is `RECURRING`; otherwise it should be empty.
        attribute?(:recurring_frequency, String, from: "recurringFrequency")
      end
    end
  end
end
