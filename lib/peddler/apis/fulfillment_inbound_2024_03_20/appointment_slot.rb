# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The fulfillment center appointment slot for the transportation option.
      AppointmentSlot = Structure.new do
        # @return [String] An identifier to a self-ship appointment slot.
        attribute(:slot_id, String, from: "slotId")

        # @return [AppointmentSlotTime]
        attribute(:slot_time, AppointmentSlotTime, from: "slotTime")
      end
    end
  end
end
