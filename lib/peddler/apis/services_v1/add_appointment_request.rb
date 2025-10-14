# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ServicesV1
      # Input for add appointment operation.
      AddAppointmentRequest = Structure.new do
        # @return [AppointmentTimeInput] Input appointment time details.
        attribute(:appointment_time, AppointmentTimeInput, from: "appointmentTime")
      end
    end
  end
end
