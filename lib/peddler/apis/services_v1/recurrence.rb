# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module ServicesV1
      # Repeated occurrence of an event in a time range.
      Recurrence = Structure.new do
        # End time of the recurrence.
        attribute(:end_time, Time, null: false, from: "endTime")

        # Days of the month when recurrence is valid.
        attribute?(:days_of_month, [Integer], from: "daysOfMonth")

        # Days of the week when recurrence is valid. If the schedule is valid every Monday, input will only contain
        # `MONDAY` in the list. Known values: `MONDAY`, `TUESDAY`, `WEDNESDAY`, `THURSDAY`, `FRIDAY`, `SATURDAY`,
        # `SUNDAY`.
        attribute?(:days_of_week, Array, from: "daysOfWeek")
      end
    end
  end
end
