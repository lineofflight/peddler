# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module ServicesV1
      # Input for rescheduled appointment operation.
      RescheduleAppointmentRequest = Structure.new do
        # Input appointment time details.
        attribute(:appointment_time, AppointmentTimeInput, null: false, from: "appointmentTime")

        # Input appointment reschedule reason.
        attribute(:reschedule_reason_code, String, null: false, from: "rescheduleReasonCode")
      end
    end
  end
end
