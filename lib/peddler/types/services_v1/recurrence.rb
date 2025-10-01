# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ServicesV1
      # Repeated occurrence of an event in a time range.
      Recurrence = Structure.new do
        # @return [String] End time of the recurrence.
        attribute(:end_time, String, from: "endTime")

        # @return [Array<Integer>] Days of the month when recurrence is valid.
        attribute?(:days_of_month, [Integer], from: "daysOfMonth")

        # @return [Array<DayOfWeek>] Days of the week when recurrence is valid. If the schedule is valid every Monday,
        # input will only contain `MONDAY` in the list.
        attribute?(:days_of_week, Array, from: "daysOfWeek")
      end
    end
  end
end
