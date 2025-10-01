# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/amazon_warehousing_and_distribution_2024_05_09/carrier_code"

module Peddler
  module Types
    module AmazonWarehousingAndDistribution20240509
      # Tracking details for the shipment. If using SPD transportation, this can be for each case. If not using SPD
      # transportation, this is a single tracking entry for the entire shipment.
      TrackingDetails = Structure.new do
        # @return [String] The identifier that is received from transportation to uniquely identify a booking.
        attribute(:booking_id, String, from: "bookingId")

        # @return [CarrierCode] Unique or identifying code for the carrier.
        attribute?(:carrier_code, CarrierCode, from: "carrierCode")
      end
    end
  end
end
