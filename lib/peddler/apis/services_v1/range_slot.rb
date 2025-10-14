# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ServicesV1
      # Capacity slots represented in a format similar to availability rules.
      RangeSlot = Structure.new do
        # @return [Integer] Capacity of the slot.
        attribute?(:capacity, Integer)

        # @return [Time] End date time of slot in ISO 8601 format with precision of seconds.
        attribute?(:end_date_time, Time, from: "endDateTime")

        # @return [Time] Start date time of slot in ISO 8601 format with precision of seconds.
        attribute?(:start_date_time, Time, from: "startDateTime")
      end
    end
  end
end
