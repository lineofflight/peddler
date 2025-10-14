# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
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
