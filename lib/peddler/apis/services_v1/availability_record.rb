# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ServicesV1
      # `AvailabilityRecord` to represent the capacity of a resource over a time range.
      AvailabilityRecord = Structure.new do
        # @return [Time] Denotes the time till when the resource is available in a day in ISO-8601 format.
        attribute(:end_time, Time, null: false, from: "endTime")

        # @return [Time] Denotes the time from when the resource is available in a day in ISO-8601 format.
        attribute(:start_time, Time, null: false, from: "startTime")

        # @return [Integer] Signifies the capacity of a resource which is available.
        attribute?(:capacity, Integer)

        # @return [Recurrence] Recurrence object containing the recurrence pattern of schedule.
        attribute?(:recurrence, Recurrence)
      end
    end
  end
end
