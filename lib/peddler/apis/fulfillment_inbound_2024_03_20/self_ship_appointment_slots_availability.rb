# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The self ship appointment time slots availability and an expiration date for which the slots can be scheduled.
      SelfShipAppointmentSlotsAvailability = Structure.new do
        # @return [Time] The time at which the self ship appointment slot expires. In [ISO
        #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format.
        attribute?(:expires_at, Time, from: "expiresAt")

        # @return [Array<AppointmentSlot>] A list of appointment slots.
        attribute?(:slots, [AppointmentSlot])
      end
    end
  end
end
