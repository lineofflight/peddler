# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FulfillmentOrderStatus
      # Notification payload that wraps nested notification data
      Payload = Structure.new do
        # @return [FulfillmentOrderStatusNotification]
        attribute(:fulfillment_order_status_notification, FulfillmentOrderStatusNotification, from: "FulfillmentOrderStatusNotification")
      end
    end
  end
end
