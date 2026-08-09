# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Tracking20260130
      # A single milestone event in a shipment's journey.
      TrackingMilestone = Structure.new do
        # @return [String] The timestamp when this milestone occurred, in UTC RFC 3339 date-time format.
        attribute(:occurred_at, String, null: false, from: "occurredAt")

        # @return [TrackingMilestoneStatus] The milestone's status details.
        attribute(:status, TrackingMilestoneStatus, null: false)

        # @return [TrackingMilestoneLocation] The location where this milestone occurred, if available. Contains an
        #   address with city, region, and country code.
        attribute?(:location, TrackingMilestoneLocation)
      end
    end
  end
end
