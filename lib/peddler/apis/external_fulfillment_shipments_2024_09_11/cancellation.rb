# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # A shipment item's cancellation details.
      Cancellation = Structure.new do
        # The type of cancellation of the item in the shipment. Known values: `SELLER_REJECTED`,
        # `MARKETPLACE_CANCELLED`, `SYSTEM_CANCELLED`.
        attribute(:cancellation_type, String, null: false, from: "cancellationType")

        # The number of items of this particular item which have been cancelled.
        attribute(:cancelled_quantity, Integer, null: false, from: "cancelledQuantity")

        # The UNIX timestamp of when the line item was cancelled.
        attribute(:cancelled_timestamp, String, null: false, from: "cancelledTimestamp")

        # The reason for the cancellation of the shipment.
        attribute?(:cancellation_reason, String, from: "cancellationReason")
      end
    end
  end
end
