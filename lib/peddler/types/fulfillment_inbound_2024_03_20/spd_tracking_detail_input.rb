# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/spd_tracking_item_input"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Contains input information to update Small Parcel Delivery (SPD) tracking information.
      SpdTrackingDetailInput = Structure.new do
        # @return [Array<SpdTrackingItemInput>] List of Small Parcel Delivery (SPD) tracking items input.
        attribute(:spd_tracking_items, [SpdTrackingItemInput], from: "spdTrackingItems")
      end
    end
  end
end
