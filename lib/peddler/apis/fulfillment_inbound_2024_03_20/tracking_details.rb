# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # Tracking information for Less-Than-Truckload (LTL) and Small Parcel Delivery (SPD) shipments.
      TrackingDetails = Structure.new do
        attribute?(:ltl_tracking_detail, LtlTrackingDetail, from: "ltlTrackingDetail")

        attribute?(:spd_tracking_detail, SpdTrackingDetail, from: "spdTrackingDetail")
      end
    end
  end
end
