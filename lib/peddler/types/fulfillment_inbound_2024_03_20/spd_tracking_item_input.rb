# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Small Parcel Delivery (SPD) tracking items input information.
      SpdTrackingItemInput = Structure.new do
        # @return [String] The ID provided by Amazon that identifies a given box. This ID is comprised of the external
        # shipment ID (which is generated after transportation has been confirmed) and the index of the box.
        attribute(:box_id, String, from: "boxId")

        # @return [String] The tracking Id associated with each box in a non-Amazon partnered Small Parcel Delivery
        # (SPD) shipment. The seller must provide this information.
        attribute(:tracking_id, String, from: "trackingId")
      end
    end
  end
end
