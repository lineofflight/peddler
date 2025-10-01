# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_inbound_2024_03_20/self_ship_appointment_details"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `scheduleSelfShipAppointment` response.
      ScheduleSelfShipAppointmentResponse = Structure.new do
        # @return [SelfShipAppointmentDetails]
        attribute(:self_ship_appointment_details, SelfShipAppointmentDetails, from: "selfShipAppointmentDetails")
      end
    end
  end
end
