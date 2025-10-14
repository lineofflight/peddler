# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ShippingV2
      # The start and end time that specifies the time interval of an event.
      TimeWindow = Structure.new do
        # @return [Time] The end time of the time window.
        attribute?(:end, Time)

        # @return [Time] The start time of the time window.
        attribute?(:start, Time)
      end
    end
  end
end
