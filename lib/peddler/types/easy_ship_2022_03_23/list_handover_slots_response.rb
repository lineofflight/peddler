# frozen_string_literal: true

require "peddler/types/easy_ship_2022_03_23/time_slot"

module Peddler
  module Types
    module EasyShip20220323
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
