# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # A shipment item's cancellation details.
      Cancellation = Structure.new do
        # @return [String] The type of cancellation of the item in the shipment.
        attribute(:cancellation_type, String, null: false, from: "cancellationType")

        # @return [Integer] The number of items of this particular item which have been cancelled.
        attribute(:cancelled_quantity, Integer, null: false, from: "cancelledQuantity")

        # @return [String] The UNIX timestamp of when the line item was cancelled.
        attribute(:cancelled_timestamp, String, null: false, from: "cancelledTimestamp")

        # @return [String] The reason for the cancellation of the shipment.
        attribute?(:cancellation_reason, String, from: "cancellationReason")
      end
    end
  end
end
