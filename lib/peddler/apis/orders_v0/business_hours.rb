# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module OrdersV0
      # Business days and hours when the destination is open for deliveries.
      BusinessHours = Structure.new do
        # Day of the week. Known values: `SUN`, `MON`, `TUE`, `WED`, `THU`, `FRI`, `SAT`.
        attribute?(:day_of_week, String, from: "DayOfWeek")

        # Time window during the day when the business is open.
        attribute?(:open_intervals, [OpenInterval], from: "OpenIntervals")
      end
    end
  end
end
