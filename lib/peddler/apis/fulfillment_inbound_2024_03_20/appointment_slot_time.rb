# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # An appointment slot time with start and end.
      AppointmentSlotTime = Structure.new do
        # @return [Time] The end timestamp of the appointment in UTC.
        attribute(:end_time, Time, from: "endTime")

        # @return [Time] The start timestamp of the appointment in UTC.
        attribute(:start_time, Time, from: "startTime")
      end
    end
  end
end
