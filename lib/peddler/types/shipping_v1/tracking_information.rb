# frozen_string_literal: true

require "peddler/types/shipping_v1/tracking_summary"
require "peddler/types/shipping_v1/event"

module Peddler
  module Types
    module ShippingV1
      # The payload schema for the getTrackingInformation operation.
      TrackingInformation = Structure.new do
        # @return [String]
        attribute(:tracking_id, String, from: "trackingId")

        # @return [TrackingSummary]
        attribute(:summary, TrackingSummary)

        # @return [String]
        attribute(:promised_delivery_date, String, from: "promisedDeliveryDate")

        # @return [Array<Event>]
        attribute(:event_history, [Event], from: "eventHistory")
      end
    end
  end
end
