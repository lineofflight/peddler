# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV1
      # The payload schema for the getTrackingInformation operation.
      TrackingInformation = Structure.new do
        # @return [Array<Event>]
        attribute(:event_history, [Event], null: false, from: "eventHistory")

        # @return [String]
        attribute(:promised_delivery_date, String, null: false, from: "promisedDeliveryDate")

        # @return [TrackingSummary]
        attribute(:summary, TrackingSummary, null: false)

        # @return [String]
        attribute(:tracking_id, String, null: false, from: "trackingId")
      end
    end
  end
end
