# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_inbound_2024_03_20/self_ship_appointment_slots_availability"
require "peddler/types/fulfillment_inbound_2024_03_20/pagination"

module Peddler
  module Types
    module FulfillmentInbound20240320
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
