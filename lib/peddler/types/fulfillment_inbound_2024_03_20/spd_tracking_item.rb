# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Contains information used to track and identify a Small Parcel Delivery (SPD) item.
      SpdTrackingItem = Structure.new do
        # @return [String] The ID provided by Amazon that identifies a given box. This ID is comprised of the external
        # shipment ID (which is generated after transportation has been confirmed) and the index of the box.
        attribute(:box_id, String, from: "boxId")

        # @return [String] The tracking ID associated with each box in a non-Amazon partnered Small Parcel Delivery
        # (SPD) shipment.
        attribute(:tracking_id, String, from: "trackingId")

        # @return [String] Indicates whether Amazon has validated the tracking number. Because shipment validation is
        # asynchronous, tracking IDs might not be validated immediately, and the status might change after a few hours.
        # If more than 24 hours have passed and the status is not yet 'VALIDATED' or `NOT_SUPPORTED`, verify the number
        # and update it if necessary. **Possible values:** `VALIDATED`, `NOT_VALIDATED`, `NOT_SUPPORTED` (Amazon is
        # unable to find tracking information for the provided tracking ID).
        attribute(:tracking_number_validation_status, String, from: "trackingNumberValidationStatus")
      end
    end
  end
end
