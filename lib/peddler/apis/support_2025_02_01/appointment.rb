# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Support20250201
      # An appointment for a contact at a future date.
      Appointment = Structure.new do
        # @return [String] The unique identifier for the scheduled appointment.
        attribute(:appointment_id, String, null: false, from: "appointmentId")

        # @return [CallbackTiming] The time window during which the appointment is scheduled.
        attribute(:callback_timing, CallbackTiming, null: false, from: "callbackTiming")

        # @return [PhoneNumber] The selling partner's phone number.
        attribute(:phone_number, PhoneNumber, null: false, from: "phoneNumber")

        # @return [String] The appointment status.
        attribute(:status, String, null: false)

        # @return [String] The person who is expected to answer the call.
        attribute?(:answering_party, String, from: "answeringParty")
      end
    end
  end
end
