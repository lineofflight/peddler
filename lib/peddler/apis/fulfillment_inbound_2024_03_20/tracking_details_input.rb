# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # Tracking information input for Less-Than-Truckload (LTL) and Small Parcel Delivery (SPD) shipments.
      TrackingDetailsInput = Structure.new do
        attribute?(:ltl_tracking_detail, LtlTrackingDetailInput, from: "ltlTrackingDetail")

        attribute?(:spd_tracking_detail, SpdTrackingDetailInput, from: "spdTrackingDetail")
      end
    end
  end
end
