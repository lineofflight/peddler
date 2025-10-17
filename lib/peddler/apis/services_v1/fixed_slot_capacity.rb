# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ServicesV1
      # Response schema for the `getFixedSlotCapacity` operation.
      FixedSlotCapacity = Structure.new do
        # @return [Array<FixedSlot>] Array of capacity slots in fixed slot format.
        attribute?(:capacities, [FixedSlot])

        # @return [String] Next page token, if there are more pages.
        attribute?(:next_page_token, String, from: "nextPageToken")

        # @return [String] Resource Identifier.
        attribute?(:resource_id, String, from: "resourceId")

        # @return [Float] The duration of each slot which is returned. This value will be a multiple of 5 and fall in
        #   the following range: 5 <= `slotDuration` <= 360.
        attribute?(:slot_duration, Float, from: "slotDuration")
      end
    end
  end
end
