# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module SellerWallet20240301
      # Parameters containing information of the expression that defines when the schedule runs. The following formats
      # are supported.
      ScheduleExpression = Structure.new do
        # @return [String] Field to specify type of the scheduled transfer
        attribute(:schedule_expression_type, String, from: "scheduleExpressionType")

        # @return [String] Field to specify recurrence of the scheduled transfer. Recurring frequency is mandatory if
        # scheduleExpressionType is set as RECURRING otherwise it should be empty field.
        attribute(:recurring_frequency, String, from: "recurringFrequency")
      end
    end
  end
end
