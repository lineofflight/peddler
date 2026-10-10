# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Orders20260101
      # Specific time interval defining the start and end times.
      TimeWindow = Structure.new do
        # The end of the time window.
        attribute?(:end_time, HourMinute, from: "endTime")

        # The beginning of the time window.
        attribute?(:start_time, HourMinute, from: "startTime")
      end
    end
  end
end
