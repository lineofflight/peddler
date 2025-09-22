# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v2/event"
require "peddler/types/shipping_v2/tracking_summary"

module Peddler
  module Types
    module ShippingV2
      # The payload for the getTracking operation.
      GetTrackingResult = Structure.new do
        # @return [String]
        attribute(:tracking_id, String, from: "trackingId")

        # @return [String]
        attribute(:alternate_leg_tracking_id, String, from: "alternateLegTrackingId")

        # @return [Array<Event>] A list of tracking events.
        attribute(:event_history, [Event], from: "eventHistory")

        # @return [String] The date and time by which the shipment is promised to be delivered.
        attribute(:promised_delivery_date, String, from: "promisedDeliveryDate")

        # @return [TrackingSummary]
        attribute(:summary, TrackingSummary)
      end
    end
  end
end
