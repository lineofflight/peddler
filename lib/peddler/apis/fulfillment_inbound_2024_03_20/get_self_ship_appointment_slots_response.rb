# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The `getSelfShipAppointmentSlots` response.
      GetSelfShipAppointmentSlotsResponse = Structure.new do
        # @return [SelfShipAppointmentSlotsAvailability]
        attribute(:self_ship_appointment_slots_availability, SelfShipAppointmentSlotsAvailability, from: "selfShipAppointmentSlotsAvailability")

        # @return [Pagination]
        attribute?(:pagination, Pagination)
      end
    end
  end
end
