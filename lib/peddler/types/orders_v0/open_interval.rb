# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/orders_v0/open_time_interval"

module Peddler
  module Types
    module OrdersV0
      # The time interval for which the business is open.
      OpenInterval = Structure.new do
        # @return [OpenTimeInterval] The time when the business opens.
        attribute(:start_time, OpenTimeInterval, from: "StartTime")

        # @return [OpenTimeInterval] The time when the business closes.
        attribute(:end_time, OpenTimeInterval, from: "EndTime")
      end
    end
  end
end
