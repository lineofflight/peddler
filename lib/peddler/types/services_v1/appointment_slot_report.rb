# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/services_v1/appointment_slot"

module Peddler
  module Types
    module ServicesV1
      # Availability information as per the service context queried.
      AppointmentSlotReport = Structure.new do
        # @return [String] Defines the type of slots.
        attribute?(:scheduling_type, String, from: "schedulingType")

        # @return [String] Start Time from which the appointment slots are generated in ISO 8601 format.
        attribute?(:start_time, String, from: "startTime")

        # @return [String] End Time up to which the appointment slots are generated in ISO 8601 format.
        attribute?(:end_time, String, from: "endTime")

        # @return [Array<AppointmentSlot>] A list of time windows along with associated capacity in which the service
        # can be performed.
        attribute?(:appointment_slots, [AppointmentSlot], from: "appointmentSlots")
      end
    end
  end
end
