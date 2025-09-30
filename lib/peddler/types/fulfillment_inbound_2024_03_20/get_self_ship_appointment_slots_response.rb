# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/pagination"
require "peddler/types/fulfillment_inbound_2024_03_20/self_ship_appointment_slots_availability"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `getSelfShipAppointmentSlots` response.
      GetSelfShipAppointmentSlotsResponse = Structure.new do
        # @return [Pagination]
        attribute?(:pagination, Pagination)

        # @return [SelfShipAppointmentSlotsAvailability]
        attribute(:self_ship_appointment_slots_availability, SelfShipAppointmentSlotsAvailability, from: "selfShipAppointmentSlotsAvailability")
      end
    end
  end
end
