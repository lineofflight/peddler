# frozen_string_literal: true

require "peddler/types/services_v1/appointment_time_input"

module Peddler
  module Types
    module ServicesV1
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
