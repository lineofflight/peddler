# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV1
      # The payload schema for the getTrackingInformation operation.
      TrackingInformation = Structure.new do
        attribute(:event_history, [Event], null: false, from: "eventHistory")

        attribute(:promised_delivery_date, String, null: false, from: "promisedDeliveryDate")

        attribute(:summary, TrackingSummary, null: false)

        attribute(:tracking_id, String, null: false, from: "trackingId")
      end
    end
  end
end
