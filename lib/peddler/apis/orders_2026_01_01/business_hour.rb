# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class Orders20260101
      # Business days and hours when the destination is open for deliveries.
      BusinessHour = Structure.new do
        # @return [String] Specific day of the week for which operating hours are being defined.
        attribute?(:day_of_week, String, from: "dayOfWeek")

        # @return [Array<TimeWindow>] Collection of time windows during which the location is available for deliveries
        #   on the specified day.
        attribute?(:time_windows, [TimeWindow], from: "timeWindows")
      end
    end
  end
end
