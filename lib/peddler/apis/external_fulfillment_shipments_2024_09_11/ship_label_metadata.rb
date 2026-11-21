# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # Metadata for a ship label document.
      ShipLabelMetadata = Structure.new do
        # The name of the carrier.
        attribute(:carrier_name, String, null: false, from: "carrierName")

        # The tracking number of the package.
        attribute(:tracking_id, String, null: false, from: "trackingId")

        # The drop-off location details. This value is populated when `handoverMethod` is `DROPOFF`.
        attribute?(:handover_location, HandoverLocation, from: "handoverLocation")

        # The time window during which the package was picked up.
        attribute?(:pickup_window, TimeWindow, from: "pickupWindow")

        # The selected slot for the ship label.
        attribute?(:shipping_option_id, String, from: "shippingOptionId")

        # A time window during which to hand over the package to Amazon Logistics.
        attribute?(:time_slot, TimeWindow, from: "timeSlot")
      end
    end
  end
end
