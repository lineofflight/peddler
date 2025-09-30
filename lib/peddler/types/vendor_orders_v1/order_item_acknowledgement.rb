# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_orders_v1/item_quantity"

module Peddler
  module Types
    module VendorOrdersV1
      # Represents the acknowledgement details for an individual order item, including the acknowledgement code,
      # acknowledged quantity, scheduled ship and delivery dates, and rejection reason (if applicable).
      OrderItemAcknowledgement = Structure.new do
        # @return [String] This indicates the acknowledgement code.
        attribute(:acknowledgement_code, String, from: "acknowledgementCode")

        # @return [ItemQuantity] Details of quantity acknowledged with the above acknowledgement code.
        attribute(:acknowledged_quantity, ItemQuantity, from: "acknowledgedQuantity")

        # @return [String] Estimated ship date per line item. Must be in ISO-8601 date/time format.
        attribute?(:scheduled_ship_date, String, from: "scheduledShipDate")

        # @return [String] Estimated delivery date per line item. Must be in ISO-8601 date/time format.
        attribute?(:scheduled_delivery_date, String, from: "scheduledDeliveryDate")

        # @return [String] Indicates the reason for rejection.
        attribute?(:rejection_reason, String, from: "rejectionReason")
      end
    end
  end
end
