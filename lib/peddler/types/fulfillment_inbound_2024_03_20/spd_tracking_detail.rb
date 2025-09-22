# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/spd_tracking_item"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Contains information related to Small Parcel Delivery (SPD) shipment tracking.
      SpdTrackingDetail = Structure.new do
        # @return [Array<SpdTrackingItem>] List of Small Parcel Delivery (SPD) tracking items.
        attribute(:spd_tracking_items, [SpdTrackingItem], from: "spdTrackingItems")
      end
    end
  end
end
