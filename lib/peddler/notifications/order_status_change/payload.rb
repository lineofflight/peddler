# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module OrderStatusChange
      # Notification payload that wraps nested notification data
      Payload = Structure.new do
        # @return [OrderStatusChangeNotification]
        attribute(:order_status_change_notification, OrderStatusChangeNotification, from: "OrderStatusChangeNotification")
      end
    end
  end
end
