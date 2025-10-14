# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class OrdersV0
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
