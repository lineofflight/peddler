# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Tracking20260130
      # Contains tracking details for a requested shipment.
      GetShipmentTrackingResponse = Structure.new do
        # @return [TrackingDetail] Current and historical tracking information for a shipment.
        attribute(:tracking_detail, TrackingDetail, null: false, from: "trackingDetail")
      end
    end
  end
end
