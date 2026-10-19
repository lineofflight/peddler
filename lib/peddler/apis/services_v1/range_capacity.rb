# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ServicesV1
      # Range capacity entity where each entry has a capacity type and corresponding slots.
      RangeCapacity = Structure.new do
        # Capacity type corresponding to the slots. Known values: `SCHEDULED_CAPACITY`, `AVAILABLE_CAPACITY`,
        # `ENCUMBERED_CAPACITY`, `RESERVED_CAPACITY`.
        attribute?(:capacity_type, String, from: "capacityType")

        # Array of capacity slots in range slot format.
        attribute?(:slots, [RangeSlot])
      end
    end
  end
end
