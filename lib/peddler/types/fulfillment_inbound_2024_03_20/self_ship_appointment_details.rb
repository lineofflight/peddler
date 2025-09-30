# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/appointment_slot_time"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Appointment details for carrier pickup or fulfillment center appointments.
      SelfShipAppointmentDetails = Structure.new do
        # @return [Float] Identifier for appointment.
        attribute?(:appointment_id, Float, from: "appointmentId")

        # @return [AppointmentSlotTime]
        attribute?(:appointment_slot_time, AppointmentSlotTime, from: "appointmentSlotTime")

        # @return [String] Status of the appointment.
        attribute?(:appointment_status, String, from: "appointmentStatus")
      end
    end
  end
end
