# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Tracking20260130
      # A time-based estimate for the shipment, such as estimated delivery date.
      TrackingEstimate = Structure.new do
        # @return [BoundedInterval] The estimated time window for this event, represented as a start and end time in UTC
        #   RFC 3339 date-time format.
        attribute(:estimated_interval, BoundedInterval, null: false, from: "estimatedInterval")

        # @return [String] The timestamp when this estimate was last modified, in UTC RFC 3339 date-time format.
        attribute(:last_updated_time, String, null: false, from: "lastUpdatedTime")

        # @return [String] The type of estimate. For example, `ESTIMATED_DELIVERY_DATE` or
        #   `ESTIMATED_TIME_OF_DEPARTURE`.
        attribute(:type, String, null: false)
      end
    end
  end
end
