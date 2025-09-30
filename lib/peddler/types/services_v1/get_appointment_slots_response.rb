# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/services_v1/appointment_slot_report"
require "peddler/types/services_v1/error"

module Peddler
  module Types
    module ServicesV1
      # The response of fetching appointment slots based on service context.
      GetAppointmentSlotsResponse = Structure.new do
        # @return [AppointmentSlotReport] The appointment slots fetched based on service context.
        attribute?(:payload, AppointmentSlotReport)

        # @return [Array<Error>] Errors occurred in getting schedule.
        attribute?(:errors, [Error])
      end
    end
  end
end
