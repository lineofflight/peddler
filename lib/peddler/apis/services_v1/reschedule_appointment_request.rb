# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ServicesV1
      # Input for rescheduled appointment operation.
      RescheduleAppointmentRequest = Structure.new do
        # @return [AppointmentTimeInput] Input appointment time details.
        attribute(:appointment_time, AppointmentTimeInput, from: "appointmentTime")

        # @return [String] Input appointment reschedule reason.
        attribute(:reschedule_reason_code, String, from: "rescheduleReasonCode")
      end
    end
  end
end
