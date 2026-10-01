# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FulfillmentOrderStatus
      # Notification payload data
      Payload = Structure.new do
        # @return [String] The type of event that triggered this notification.
        attribute(:event_type, String, null: false, from: "eventType")

        # @return [String] The merchant identifier for the fulfillment order.
        attribute(:merchant_id, String, null: false, from: "merchantId")

        # @return [Hash] Contains detailed information about the fulfillment order.
        attribute(:order, Hash, null: false)

        # @return [String] The identifier of the fulfillment service used for this operation.
        attribute?(:fulfillment_service_id, String, from: "fulfillmentServiceId")
      end
    end
  end
end
