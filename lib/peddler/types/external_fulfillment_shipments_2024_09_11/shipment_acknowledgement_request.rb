# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/external_fulfillment_shipments_2024_09_11/line_item_with_reason"

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
      # Information about the shipment and its line items, used to confirm or reject line items.
      ShipmentAcknowledgementRequest = Structure.new do
        # @return [Array<LineItemWithReason>] Details about the line items from the shipment that are being confirmed or
        # rejected by the seller.
        attribute(:line_items, [LineItemWithReason], from: "lineItems")

        # @return [String] A unique identifier for every shipment rejection.
        attribute?(:reference_id, String, from: "referenceId")
      end
    end
  end
end
