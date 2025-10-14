# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ShippingV1
      # The time range.
      TimeRange = Structure.new do
        # @return [Time] The end date and time. This must come after the value of start. This defaults to the next
        # business day from the start.
        attribute?(:end, Time)

        # @return [Time] The start date and time. This defaults to the current date and time.
        attribute?(:start, Time)
      end
    end
  end
end
