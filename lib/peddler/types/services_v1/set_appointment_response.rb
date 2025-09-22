# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/services_v1/warning"
require "peddler/types/services_v1/error"

module Peddler
  module Types
    module ServicesV1
      # Response schema for the `addAppointmentForServiceJobByServiceJobId` and
      # `rescheduleAppointmentForServiceJobByServiceJobId` operations.
      SetAppointmentResponse = Structure.new do
        # @return [String] New appointment identifier generated during the `addAppointmentForServiceJobByServiceJobId`
        # or `rescheduleAppointmentForServiceJobByServiceJobId` operations.
        attribute(:appointment_id, String, from: "appointmentId")

        # @return [Array<Warning>] Warnings generated during the `addAppointmentForServiceJobByServiceJobId` or
        # `rescheduleAppointmentForServiceJobByServiceJobId` operations.
        attribute(:warnings, [Warning])

        # @return [Array<Error>] Errors occurred during during the `addAppointmentForServiceJobByServiceJobId` or
        # `rescheduleAppointmentForServiceJobByServiceJobId` operations.
        attribute(:errors, [Error])
      end
    end
  end
end
