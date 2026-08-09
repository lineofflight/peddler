# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Tracking20260130
      # A time interval defined by a start time and end time.
      BoundedInterval = Structure.new do
        # @return [String] The inclusive end of the interval, in UTC RFC 3339 date-time format. Must not precede
        #   `startTime`.
        attribute(:end_time, String, null: false, from: "endTime")

        # @return [String] The inclusive start of the interval, in UTC RFC 3339 date-time format.
        attribute(:start_time, String, null: false, from: "startTime")
      end
    end
  end
end
