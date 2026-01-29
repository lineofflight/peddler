# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Current status and detailed tracking information for a shipping package throughout the delivery process.
      PackageStatus = Structure.new do
        # @return [String] Primary status classification of the package in the shipping workflow.
        attribute(:status, String)

        # @return [String] Granular status information providing specific details about the package's current location
        #   and handling stage.
        #
        # **Possible values:** - `PENDING_SCHEDULE` (Package awaiting pickup scheduling) - `PENDING_PICK_UP` (Package
        #   ready for carrier collection from seller) - `PENDING_DROP_OFF` (Package awaiting seller delivery to carrier)
        #   - `LABEL_CANCELLED` (Shipping label canceled by seller) - `PICKED_UP` (Package collected by carrier from
        #   seller location) - `DROPPED_OFF` (Package delivered to carrier by seller) - `AT_ORIGIN_FC` (Package at
        #   originating fulfillment center) - `AT_DESTINATION_FC` (Package at destination fulfillment center) -
        #   `DELIVERED` (Package successfully delivered to recipient) - `REJECTED_BY_BUYER` (Package refused by intended
        #   recipient) - `UNDELIVERABLE` (Package cannot be delivered due to address or access issues) -
        #   `RETURNING_TO_SELLER` (Package in transit back to seller) - `RETURNED_TO_SELLER` (Package successfully
        #   returned to seller) - `LOST` (Package location unknown or confirmed lost) - `OUT_FOR_DELIVERY` (Package on
        #   delivery vehicle for final delivery) - `DAMAGED` (Package damaged during transit)
        attribute?(:detailed_status, String, from: "detailedStatus")
      end
    end
  end
end
