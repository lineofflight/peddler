# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # Appointment details for carrier pickup or fulfillment center appointments.
      SelfShipAppointmentDetails = Structure.new do
        # Identifier for appointment.
        attribute?(:appointment_id, Float, from: "appointmentId")

        attribute?(:appointment_slot_time, AppointmentSlotTime, from: "appointmentSlotTime")

        # Status of the appointment.
        attribute?(:appointment_status, String, from: "appointmentStatus")
      end
    end
  end
end
