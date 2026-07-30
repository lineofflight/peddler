# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # The time range within which an event (for example, a delivery) will occur.
      TimeInterval = Structure.new do
        # @return [String] The latest point in a date range in ISO 8601 date-time format.
        attribute(:end_time, String, null: false, from: "endTime")

        # @return [String] The earliest point in a date range in ISO 8601 date-time format.
        attribute(:start_time, String, null: false, from: "startTime")
      end
    end
  end
end
