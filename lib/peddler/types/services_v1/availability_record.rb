# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/services_v1/recurrence"

module Peddler
  module Types
    module ServicesV1
      # `AvailabilityRecord` to represent the capacity of a resource over a time range.
      AvailabilityRecord = Structure.new do
        # @return [String] Denotes the time till when the resource is available in a day in ISO-8601 format.
        attribute(:end_time, String, from: "endTime")

        # @return [String] Denotes the time from when the resource is available in a day in ISO-8601 format.
        attribute(:start_time, String, from: "startTime")

        # @return [Integer] Signifies the capacity of a resource which is available.
        attribute?(:capacity, Integer)

        # @return [Recurrence] Recurrence object containing the recurrence pattern of schedule.
        attribute?(:recurrence, Recurrence)
      end
    end
  end
end
