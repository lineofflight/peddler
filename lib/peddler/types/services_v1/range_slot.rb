# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ServicesV1
      # Capacity slots represented in a format similar to availability rules.
      RangeSlot = Structure.new do
        # @return [String] Start date time of slot in ISO 8601 format with precision of seconds.
        attribute(:start_date_time, String, from: "startDateTime")

        # @return [String] End date time of slot in ISO 8601 format with precision of seconds.
        attribute(:end_date_time, String, from: "endDateTime")

        # @return [Integer] Capacity of the slot.
        attribute(:capacity, Integer)
      end
    end
  end
end
