# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ServicesV1
      # Request schema for the `getRangeSlotCapacity` operation. This schema is used to define the time range and
      # capacity types that are being queried.
      RangeSlotCapacityQuery = Structure.new do
        # @return [Array<CapacityType>] An array of capacity types which are being requested. Default value is
        # `[SCHEDULED_CAPACITY]`.
        attribute(:capacity_types, Array, from: "capacityTypes")

        # @return [String] Start date time from which the capacity slots are being requested in ISO 8601 format.
        attribute(:start_date_time, String, from: "startDateTime")

        # @return [String] End date time up to which the capacity slots are being requested in ISO 8601 format.
        attribute(:end_date_time, String, from: "endDateTime")
      end
    end
  end
end
