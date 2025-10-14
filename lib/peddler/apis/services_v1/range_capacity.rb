# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ServicesV1
      # Range capacity entity where each entry has a capacity type and corresponding slots.
      RangeCapacity = Structure.new do
        # @return [String] Capacity type corresponding to the slots.
        attribute?(:capacity_type, String, from: "capacityType")

        # @return [Array<RangeSlot>] Array of capacity slots in range slot format.
        attribute?(:slots, [RangeSlot])
      end
    end
  end
end
