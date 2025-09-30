# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/ltl_tracking_detail"
require "peddler/types/fulfillment_inbound_2024_03_20/spd_tracking_detail"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Tracking information for Less-Than-Truckload (LTL) and Small Parcel Delivery (SPD) shipments.
      TrackingDetails = Structure.new do
        # @return [LtlTrackingDetail]
        attribute?(:ltl_tracking_detail, LtlTrackingDetail, from: "ltlTrackingDetail")

        # @return [SpdTrackingDetail]
        attribute?(:spd_tracking_detail, SpdTrackingDetail, from: "spdTrackingDetail")
      end
    end
  end
end
