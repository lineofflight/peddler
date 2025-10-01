# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/external_fulfillment_returns_2024_09_11/tracking_info"

module Peddler
  module Types
    module ExternalFulfillmentReturns20240911
      # Provides details about the replanned returns.
      ReplanningDetails = Structure.new do
        # @return [Array<TrackingInfo>] A list of all the previous tracking information for the return.
        attribute?(:previous_tracking_info, [TrackingInfo], from: "previousTrackingInfo")
      end
    end
  end
end
