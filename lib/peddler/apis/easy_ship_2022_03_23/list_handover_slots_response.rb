# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module EasyShip20220323
      # The response schema for the `listHandoverSlots` operation.
      ListHandoverSlotsResponse = Structure.new do
        attribute(:amazon_order_id, String, null: false, from: "amazonOrderId")

        attribute(:time_slots, [TimeSlot], null: false, from: "timeSlots")
      end
    end
  end
end
