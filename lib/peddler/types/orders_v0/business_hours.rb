# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/orders_v0/open_interval"

module Peddler
  module Types
    module OrdersV0
      # Business days and hours when the destination is open for deliveries.
      BusinessHours = Structure.new do
        # @return [String] Day of the week.
        attribute?(:day_of_week, String, from: "DayOfWeek")

        # @return [Array<OpenInterval>] Time window during the day when the business is open.
        attribute?(:open_intervals, [OpenInterval], from: "OpenIntervals")
      end
    end
  end
end
