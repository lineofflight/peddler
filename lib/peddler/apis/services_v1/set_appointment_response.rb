# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ServicesV1
      # Response schema for the `addAppointmentForServiceJobByServiceJobId` and
      # `rescheduleAppointmentForServiceJobByServiceJobId` operations.
      SetAppointmentResponse = Structure.new do
        # @return [String] New appointment identifier generated during the `addAppointmentForServiceJobByServiceJobId`
        #   or `rescheduleAppointmentForServiceJobByServiceJobId` operations.
        attribute?(:appointment_id, String, from: "appointmentId")

        # @return [Array<Error>] Errors occurred during during the `addAppointmentForServiceJobByServiceJobId` or
        #   `rescheduleAppointmentForServiceJobByServiceJobId` operations.
        attribute?(:errors, [Error])

        # @return [Array<Warning>] Warnings generated during the `addAppointmentForServiceJobByServiceJobId` or
        #   `rescheduleAppointmentForServiceJobByServiceJobId` operations.
        attribute?(:warnings, [Warning])
      end
    end
  end
end
