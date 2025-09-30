# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/appointment_slot"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The self ship appointment time slots availability and an expiration date for which the slots can be scheduled.
      SelfShipAppointmentSlotsAvailability = Structure.new do
        # @return [String] The time at which the self ship appointment slot expires. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format.
        attribute?(:expires_at, String, from: "expiresAt")

        # @return [Array<AppointmentSlot>] A list of appointment slots.
        attribute?(:slots, [AppointmentSlot])
      end
    end
  end
end
