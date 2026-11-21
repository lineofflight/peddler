# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module ShipmentTrackingMilestoneChanged
      # The tracking information for the shipment.
      TrackingDetail = Structure.new do
        # The tracking identifiers associated with this shipment. Multiple identifier types may be populated
        # simultaneously.
        attribute(:identifier, TrackingIdentifier, null: false)

        # A chronological list of all milestone events for the shipment, from most recent to oldest.
        attribute(:milestone_history, [TrackingMilestone], null: false, from: "milestoneHistory")

        # The most recent milestone event data for the shipment.
        attribute?(:latest_milestone, TrackingMilestone, from: "latestMilestone")

        # List of time-based estimated intervals for the shipment, such as estimated delivery date and estimated time of
        # departure.
        attribute?(:tracking_estimates, [TrackingEstimate], from: "trackingEstimates")

        # URL where the developer or end customer can view the shipment's tracking information.
        attribute?(:tracking_url, String, from: "trackingUrl")
      end
    end
  end
end
