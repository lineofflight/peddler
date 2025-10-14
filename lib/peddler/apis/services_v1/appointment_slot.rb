# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ServicesV1
      # A time window along with associated capacity in which the service can be performed.
      AppointmentSlot = Structure.new do
        # @return [Integer] Number of resources for which a slot can be reserved.
        attribute?(:capacity, Integer)

        # @return [Time] Time window end time in ISO 8601 format.
        attribute?(:end_time, Time, from: "endTime")

        # @return [Time] Time window start time in ISO 8601 format.
        attribute?(:start_time, Time, from: "startTime")
      end
    end
  end
end
