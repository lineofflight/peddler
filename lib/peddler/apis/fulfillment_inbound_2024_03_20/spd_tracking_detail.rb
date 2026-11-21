# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # Contains information related to Small Parcel Delivery (SPD) shipment tracking.
      SpdTrackingDetail = Structure.new do
        # List of Small Parcel Delivery (SPD) tracking items.
        attribute?(:spd_tracking_items, [SpdTrackingItem], from: "spdTrackingItems")
      end
    end
  end
end
