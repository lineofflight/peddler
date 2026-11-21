# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # Contains input information to update Small Parcel Delivery (SPD) tracking information.
      SpdTrackingDetailInput = Structure.new do
        # List of Small Parcel Delivery (SPD) tracking items input.
        attribute(:spd_tracking_items, [SpdTrackingItemInput], null: false, from: "spdTrackingItems")
      end
    end
  end
end
