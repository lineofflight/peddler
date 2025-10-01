# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/services_v1/error"
require "peddler/types/services_v1/warning"

module Peddler
  module Types
    module ServicesV1
      # Response schema for the `addAppointmentForServiceJobByServiceJobId` and
      # `rescheduleAppointmentForServiceJobByServiceJobId` operations.
      SetAppointmentResponse = Structure.new do
        # @return [String] New appointment identifier generated during the `addAppointmentForServiceJobByServiceJobId`
        # or `rescheduleAppointmentForServiceJobByServiceJobId` operations.
        attribute?(:appointment_id, String, from: "appointmentId")

        # @return [Array<Error>] Errors occurred during during the `addAppointmentForServiceJobByServiceJobId` or
        # `rescheduleAppointmentForServiceJobByServiceJobId` operations.
        attribute?(:errors, [Error])

        # @return [Array<Warning>] Warnings generated during the `addAppointmentForServiceJobByServiceJobId` or
        # `rescheduleAppointmentForServiceJobByServiceJobId` operations.
        attribute?(:warnings, [Warning])
      end
    end
  end
end
