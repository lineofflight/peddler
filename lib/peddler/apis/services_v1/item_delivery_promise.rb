# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module ServicesV1
      # Promised delivery information for the item.
      ItemDeliveryPromise = Structure.new do
        # The date and time of the end of the promised delivery window in ISO 8601 format.
        attribute?(:end_time, Time, from: "endTime")

        # The date and time of the start of the promised delivery window in ISO 8601 format.
        attribute?(:start_time, Time, from: "startTime")
      end
    end
  end
end
