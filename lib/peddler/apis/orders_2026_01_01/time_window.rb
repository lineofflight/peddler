# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Specific time interval defining the start and end times.
      TimeWindow = Structure.new do
        # @return [HourMinute] The end of the time window.
        attribute?(:end_time, HourMinute, from: "endTime")

        # @return [HourMinute] The beginning of the time window.
        attribute?(:start_time, HourMinute, from: "startTime")
      end
    end
  end
end
