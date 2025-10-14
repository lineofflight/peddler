# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ServicesV1
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
