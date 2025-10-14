# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV1
      # The payload schema for the getTrackingInformation operation.
      TrackingInformation = Structure.new do
        # @return [Array<Event>]
        attribute(:event_history, [Event], from: "eventHistory")

        # @return [String]
        attribute(:promised_delivery_date, String, from: "promisedDeliveryDate")

        # @return [TrackingSummary]
        attribute(:summary, TrackingSummary)

        # @return [String]
        attribute(:tracking_id, String, from: "trackingId")
      end
    end
  end
end
