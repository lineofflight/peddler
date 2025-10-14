# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ServicesV1
      # In this slot format each slot only has the requested capacity types. This slot size is as specified by slot
      # duration.
      FixedSlot = Structure.new do
        # @return [Integer] Available capacity corresponding to the slot. This capacity represents the capacity
        # available for allocation to reservations.
        attribute?(:available_capacity, Integer, from: "availableCapacity")

        # @return [Integer] Encumbered capacity corresponding to the slot. This capacity represents the capacity
        # allocated for Amazon Jobs/Appointments/Orders.
        attribute?(:encumbered_capacity, Integer, from: "encumberedCapacity")

        # @return [Integer] Reserved capacity corresponding to the slot. This capacity represents the capacity made
        # unavailable due to events like Breaks/Leaves/Lunch.
        attribute?(:reserved_capacity, Integer, from: "reservedCapacity")

        # @return [Integer] Scheduled capacity corresponding to the slot. This capacity represents the originally
        # allocated capacity as per resource schedule.
        attribute?(:scheduled_capacity, Integer, from: "scheduledCapacity")

        # @return [Time] Start date time of slot in ISO 8601 format with precision of seconds.
        attribute?(:start_date_time, Time, from: "startDateTime")
      end
    end
  end
end
