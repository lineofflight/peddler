# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Tracking details for the shipment. If using SPD transportation, this can be for each case. If not using SPD
      # transportation, this is a single tracking entry for the entire shipment.
      TrackingDetails = Structure.new do
        # @return [String] The identifier that is received from transportation to uniquely identify a booking.
        attribute(:booking_id, String, null: false, from: "bookingId")

        # @return [CarrierCode] Unique or identifying code for the carrier.
        attribute?(:carrier_code, CarrierCode, from: "carrierCode")
      end
    end
  end
end
