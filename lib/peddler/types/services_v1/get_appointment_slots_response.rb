# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/services_v1/error"
require "peddler/types/services_v1/appointment_slot_report"

module Peddler
  module Types
    module ServicesV1
      # The response of fetching appointment slots based on service context.
      GetAppointmentSlotsResponse = Structure.new do
        # @return [Array<Error>] Errors occurred in getting schedule.
        attribute?(:errors, [Error])

        # @return [AppointmentSlotReport] The appointment slots fetched based on service context.
        attribute?(:payload, AppointmentSlotReport)
      end
    end
  end
end
