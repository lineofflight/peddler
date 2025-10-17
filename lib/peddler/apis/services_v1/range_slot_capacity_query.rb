# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ServicesV1
      # Request schema for the `getRangeSlotCapacity` operation. This schema is used to define the time range and
      # capacity types that are being queried.
      RangeSlotCapacityQuery = Structure.new do
        # @return [Time] End date time up to which the capacity slots are being requested in ISO 8601 format.
        attribute(:end_date_time, Time, from: "endDateTime")

        # @return [Time] Start date time from which the capacity slots are being requested in ISO 8601 format.
        attribute(:start_date_time, Time, from: "startDateTime")

        # @return [Array<CapacityType>] An array of capacity types which are being requested. Default value is
        #   `[SCHEDULED_CAPACITY]`.
        attribute?(:capacity_types, Array, from: "capacityTypes")
      end
    end
  end
end
