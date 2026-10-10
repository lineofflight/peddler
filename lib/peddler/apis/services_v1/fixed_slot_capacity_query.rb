# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module ServicesV1
      # Request schema for the `getFixedSlotCapacity` operation. This schema is used to define the time range, capacity
      # types and slot duration which are being queried.
      FixedSlotCapacityQuery = Structure.new do
        # End date time up to which the capacity slots are being requested in ISO 8601 format.
        attribute(:end_date_time, Time, null: false, from: "endDateTime")

        # Start date time from which the capacity slots are being requested in ISO 8601 format.
        attribute(:start_date_time, Time, null: false, from: "startDateTime")

        # An array of capacity types which are being requested. Default value is `[SCHEDULED_CAPACITY]`.
        attribute?(:capacity_types, Array, from: "capacityTypes")

        # Size in which slots are being requested. This value should be a multiple of 5 and fall in the range: 5 <=
        # `slotDuration` <= 360.
        attribute?(:slot_duration, Float, from: "slotDuration")
      end
    end
  end
end
