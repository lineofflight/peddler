# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
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
