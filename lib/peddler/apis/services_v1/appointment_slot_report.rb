# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ServicesV1
      # Availability information as per the service context queried.
      AppointmentSlotReport = Structure.new do
        # @return [Array<AppointmentSlot>] A list of time windows along with associated capacity in which the service
        #   can be performed.
        attribute?(:appointment_slots, [AppointmentSlot], from: "appointmentSlots")

        # @return [Time] End Time up to which the appointment slots are generated in ISO 8601 format.
        attribute?(:end_time, Time, from: "endTime")

        # @return [String] Defines the type of slots.
        attribute?(:scheduling_type, String, from: "schedulingType")

        # @return [Time] Start Time from which the appointment slots are generated in ISO 8601 format.
        attribute?(:start_time, Time, from: "startTime")
      end
    end
  end
end
