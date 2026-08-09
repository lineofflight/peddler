# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Tracking20260130
      # Tracking information for the shipment identifier.
      TrackingDetail = Structure.new do
        # @return [TrackingIdentifier] The tracking identifier used to look up this shipment (for example, `id`,
        #   `acsin`, or `containerNumber`).
        attribute(:identifier, TrackingIdentifier, null: false)

        # @return [Array<TrackingMilestone>] A chronological list of all milestone events for the shipment, from most
        #   recent to oldest.
        attribute(:milestone_history, [TrackingMilestone], null: false, from: "milestoneHistory")

        # @return [TrackingMilestone] The most recent milestone event for the shipment.
        attribute?(:latest_milestone, TrackingMilestone, from: "latestMilestone")

        # @return [Array<TrackingEstimate>] A list of time-based estimated intervals for the shipment, such as estimated
        #   delivery date.
        attribute?(:tracking_estimates, [TrackingEstimate], from: "trackingEstimates")

        # @return [String] The URL to view the shipment's tracking information.
        attribute?(:tracking_url, String, from: "trackingUrl")
      end
    end
  end
end
