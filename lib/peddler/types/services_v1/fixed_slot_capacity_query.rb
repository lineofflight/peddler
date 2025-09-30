# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ServicesV1
      # Request schema for the `getFixedSlotCapacity` operation. This schema is used to define the time range, capacity
      # types and slot duration which are being queried.
      FixedSlotCapacityQuery = Structure.new do
        # @return [Array<CapacityType>] An array of capacity types which are being requested. Default value is
        # `[SCHEDULED_CAPACITY]`.
        attribute?(:capacity_types, Array, from: "capacityTypes")

        # @return [Float] Size in which slots are being requested. This value should be a multiple of 5 and fall in the
        # range: 5 <= `slotDuration` <= 360.
        attribute?(:slot_duration, Float, from: "slotDuration")

        # @return [String] Start date time from which the capacity slots are being requested in ISO 8601 format.
        attribute(:start_date_time, String, from: "startDateTime")

        # @return [String] End date time up to which the capacity slots are being requested in ISO 8601 format.
        attribute(:end_date_time, String, from: "endDateTime")
      end
    end
  end
end
