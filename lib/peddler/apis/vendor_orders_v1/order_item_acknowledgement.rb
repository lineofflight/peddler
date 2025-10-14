# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class VendorOrdersV1
      # Represents the acknowledgement details for an individual order item, including the acknowledgement code,
      # acknowledged quantity, scheduled ship and delivery dates, and rejection reason (if applicable).
      OrderItemAcknowledgement = Structure.new do
        # @return [ItemQuantity] Details of quantity acknowledged with the above acknowledgement code.
        attribute(:acknowledged_quantity, ItemQuantity, from: "acknowledgedQuantity")

        # @return [String] This indicates the acknowledgement code.
        attribute(:acknowledgement_code, String, from: "acknowledgementCode")

        # @return [String] Indicates the reason for rejection.
        attribute?(:rejection_reason, String, from: "rejectionReason")

        # @return [Time] Estimated delivery date per line item. Must be in ISO-8601 date/time format.
        attribute?(:scheduled_delivery_date, Time, from: "scheduledDeliveryDate")

        # @return [Time] Estimated ship date per line item. Must be in ISO-8601 date/time format.
        attribute?(:scheduled_ship_date, Time, from: "scheduledShipDate")
      end
    end
  end
end
