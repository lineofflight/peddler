# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/external_fulfillment_returns_2024_09_11/tracking_info"

module Peddler
  module Types
    module ExternalFulfillmentReturns20240911
      # Information about the shipping of the return packages.
      ReturnShippingInfo = Structure.new do
        # @return [String] The date and time when the seller received the return.
        attribute?(:delivery_date_time, String, from: "deliveryDateTime")

        # @return [TrackingInfo]
        attribute?(:forward_tracking_info, TrackingInfo, from: "forwardTrackingInfo")

        # @return [String] The date and time when the return was picked up.
        attribute?(:pickup_date_time, String, from: "pickupDateTime")

        # @return [TrackingInfo]
        attribute?(:reverse_tracking_info, TrackingInfo, from: "reverseTrackingInfo")
      end
    end
  end
end
