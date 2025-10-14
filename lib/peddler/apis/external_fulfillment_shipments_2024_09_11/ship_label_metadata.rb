# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # Metadata for a ship label document.
      ShipLabelMetadata = Structure.new do
        # @return [String] The name of the carrier.
        attribute(:carrier_name, String, from: "carrierName")

        # @return [String] The tracking number of the package.
        attribute(:tracking_id, String, from: "trackingId")

        # @return [TimeWindow] The time window during which the package was picked up.
        attribute?(:pickup_window, TimeWindow, from: "pickupWindow")

        # @return [String] The selected slot for the ship label.
        attribute?(:shipping_option_id, String, from: "shippingOptionId")

        # @return [TimeWindow] A time window during which to hand over the package to Amazon Logistics.
        attribute?(:time_slot, TimeWindow, from: "timeSlot")
      end
    end
  end
end
