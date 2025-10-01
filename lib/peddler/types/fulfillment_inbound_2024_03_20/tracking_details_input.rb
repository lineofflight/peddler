# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_inbound_2024_03_20/ltl_tracking_detail_input"
require "peddler/types/fulfillment_inbound_2024_03_20/spd_tracking_detail_input"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Tracking information input for Less-Than-Truckload (LTL) and Small Parcel Delivery (SPD) shipments.
      TrackingDetailsInput = Structure.new do
        # @return [LtlTrackingDetailInput]
        attribute?(:ltl_tracking_detail, LtlTrackingDetailInput, from: "ltlTrackingDetail")

        # @return [SpdTrackingDetailInput]
        attribute?(:spd_tracking_detail, SpdTrackingDetailInput, from: "spdTrackingDetail")
      end
    end
  end
end
