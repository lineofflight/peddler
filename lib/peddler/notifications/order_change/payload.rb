# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module OrderChange
      # Notification payload that wraps nested notification data
      Payload = Structure.new do
        # @return [OrderChangeNotification]
        attribute(:order_change_notification, OrderChangeNotification, from: "OrderChangeNotification")
      end
    end
  end
end
