# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class EasyShip20220323
      # The response schema for the `listHandoverSlots` operation.
      ListHandoverSlotsResponse = Structure.new do
        # @return [String]
        attribute(:amazon_order_id, String, from: "amazonOrderId")

        # @return [Array<TimeSlot>]
        attribute(:time_slots, [TimeSlot], from: "timeSlots")
      end
    end
  end
end
