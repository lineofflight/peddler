# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/orders_v0/open_time_interval"

module Peddler
  module Types
    module OrdersV0
      # The time interval for which the business is open.
      OpenInterval = Structure.new do
        # @return [OpenTimeInterval] The time when the business closes.
        attribute?(:end_time, OpenTimeInterval, from: "EndTime")

        # @return [OpenTimeInterval] The time when the business opens.
        attribute?(:start_time, OpenTimeInterval, from: "StartTime")
      end
    end
  end
end
