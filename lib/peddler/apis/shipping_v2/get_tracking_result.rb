# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ShippingV2
      # The payload for the getTracking operation.
      GetTrackingResult = Structure.new do
        # @return [String]
        attribute(:alternate_leg_tracking_id, String, null: false, from: "alternateLegTrackingId")

        # @return [Array<Event>] A list of tracking events.
        attribute(:event_history, [Event], null: false, from: "eventHistory")

        # @return [Time] The date and time by which the shipment is promised to be delivered.
        attribute(:promised_delivery_date, Time, null: false, from: "promisedDeliveryDate")

        # @return [TrackingSummary]
        attribute(:summary, TrackingSummary, null: false)

        # @return [String]
        attribute(:tracking_id, String, null: false, from: "trackingId")
      end
    end
  end
end
