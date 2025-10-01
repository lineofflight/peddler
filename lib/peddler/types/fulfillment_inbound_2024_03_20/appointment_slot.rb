# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_inbound_2024_03_20/appointment_slot_time"

module Peddler
  module Types
    module FulfillmentInbound20240320
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
