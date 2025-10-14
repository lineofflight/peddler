# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class FulfillmentInbound20240320
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
