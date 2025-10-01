# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Summary information about a shipment.
      ShipmentSummary = Structure.new do
        # @return [String] Identifier of a shipment. A shipment contains the boxes and units being inbounded.
        attribute(:shipment_id, String, from: "shipmentId")

        # @return [String] The status of a shipment. The state of the shipment will typically start as `UNCONFIRMED`,
        # then transition to `WORKING` after a placement option has been confirmed, and then to `READY_TO_SHIP` once
        # labels are generated.
        #
        # Possible values: `ABANDONED`, `CANCELLED`, `CHECKED_IN`, `CLOSED`, `DELETED`, `DELIVERED`, `IN_TRANSIT`,
        # `MIXED`, `READY_TO_SHIP`, `RECEIVING`, `SHIPPED`, `UNCONFIRMED`, `WORKING`
        attribute(:status, String)
      end
    end
  end
end
