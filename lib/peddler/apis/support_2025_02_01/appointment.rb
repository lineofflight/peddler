# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Support20250201
      # An appointment for a contact at a future date.
      Appointment = Structure.new do
        # The unique identifier for the scheduled appointment.
        attribute(:appointment_id, String, null: false, from: "appointmentId")

        # The time window during which the appointment is scheduled.
        attribute(:callback_timing, CallbackTiming, null: false, from: "callbackTiming")

        # The selling partner's phone number.
        attribute(:phone_number, PhoneNumber, null: false, from: "phoneNumber")

        # The appointment status. Known values: `SCHEDULED`, `CANCELLED`, `MISSED`, `COMPLETED`.
        attribute(:status, String, null: false)

        # The person who is expected to answer the call. Known values: `RECEPTIONIST`.
        attribute?(:answering_party, String, from: "answeringParty")
      end
    end
  end
end
