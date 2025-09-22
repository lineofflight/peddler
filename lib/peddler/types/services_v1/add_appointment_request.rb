# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/services_v1/appointment_time_input"

module Peddler
  module Types
    module ServicesV1
      # Input for add appointment operation.
      AddAppointmentRequest = Structure.new do
        # @return [AppointmentTimeInput] Input appointment time details.
        attribute(:appointment_time, AppointmentTimeInput, from: "appointmentTime")
      end
    end
  end
end
